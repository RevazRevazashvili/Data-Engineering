-- Optimazing Technique - SQL Partitioning
USE MySalesDB

/*
	SQL Partitioning divides big table into smaller partitions while still
	being treated as a single logical table.
	By Partitioning the whole table splits into smaller tables and those table may be 
	stored in different servers, that allows parallel processing. With partitioning
	database does not need to read an entire table. it can read only a one partition( of course
	it depends on a query).
*/

-- Step 1: Create a partition function
CREATE PARTITION FUNCTION PartitionByYear (DATE) -- datatype by which we want to partition
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31') -- LEFT means that boundary will stay in left part

-- To check systems partition functions we can use below example
-- query lists all existing partition function
SELECT
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions

-- Step 2: Create Filegroups
-- Filegroups are containers where the partition of our table will be stored.
ALTER DATABASE MySalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE MySalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE MySalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE MySalesDB ADD FILEGROUP FG_2026;

-- if we want to remove a filegroup we use this
ALTER DATABASE MySalesDB REMOVE FILEGROUP FG_2023

-- To query all filegroups that are in the system
SELECT * FROM sys.filegroups WHERE TYPE = 'FG'

-- Step 3: Add .ndf Files(actual data files) to each filegroups
ALTER DATABASE MySalesDB ADD FILE
(
	NAME = p_2023, -- logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\p_2023.ndf'
) TO FILEGROUP FG_2023;
ALTER DATABASE MySalesDB ADD FILE
(
	NAME = p_2024, -- logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\p_2024.ndf'
) TO FILEGROUP FG_2024;
ALTER DATABASE MySalesDB ADD FILE
(
	NAME = p_2025, -- logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\p_2025.ndf'
) TO FILEGROUP FG_2025;
ALTER DATABASE MySalesDB ADD FILE
(
	NAME = p_2026, -- logical name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\p_2026.ndf'
) TO FILEGROUP FG_2026;


-- query the metadata
SELECT
	fg.name AS fileGroupName,
	mf.name AS logicalFileName,
	mf.physical_name AS phisicalFileName,
	mf.size / 128 AS sizeInMB
FROM 
	sys.filegroups fg
JOIN
	sys.master_files mf ON fg.data_space_id=mf.data_space_id
WHERE
	mf.database_id=DB_ID('MySalesDB')


-- Step 4: Create Partition Scheme
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)


-- query lists all partition scheme
SELECT
	ps.name AS partitionSchemeName,
	pf.name AS partitionfunctionName,
	ds.destination_id AS partitionNumber,
	fg.name AS fileGroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id=pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id=ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id=fg.data_space_id


-- Step 5: Create the partitioned table
CREATE TABLE orders_partitioned
(
	orderID INT,
	orderDate DATE,
	sales INT
) ON SchemePartitionByYear (orderDate)


-- Step 6: Insert data into the partitioned table
INSERT INTO orders_partitioned VALUES(1, '2023-05-15', 100);
INSERT INTO orders_partitioned VALUES(2, '2024-12-13', 300);
INSERT INTO orders_partitioned VALUES(3, '2025-12-31', 300);
INSERT INTO orders_partitioned VALUES(4, '2026-01-01', 300);


SELECT * FROM orders_partitioned


-- checking
SELECT
	p.partition_number AS partitionNumber,
	f.name AS partitionFileGroup,
	p.rows AS numberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number=dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id=f.data_space_id
WHERE OBJECT_NAME(p.object_id)='orders_partitioned'
