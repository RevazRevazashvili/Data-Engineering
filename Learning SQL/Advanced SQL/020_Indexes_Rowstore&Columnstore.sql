-- Optimazing Technique - Index
USE MySalesDB


-- Rowstore Index and Columnstore Index


/*
						Rowstore Index				VS				Columnstore Index
	
	Definition			Orgainzes and stores data row by row		Orgainzes and stores data column by column

	Storage
	Efficiency			Less efficient in storage					Highly efficient with Compression

	Read/Write
	Optimizations		Fair speed for read & write opperations		Fast read performance, Slow write performance

	I/O Efficiency		Higher(retrieves all columns)				Lower(retrieves specific columns)

	Best for...			OLTP(Transactions) commerce, banking		OLAP(Analytical) Data warehouse
						financial systems, order processing			business inteligence, reporting, analytics
	
	Use Case			-High-frequency transaction applications		-Big Data Analytics
						-Quick access to complete records			-Scanning of large datasets
																	-Fast aggregation
*/


-- creating clustered columnstore index
-- DROP INDEX idx_DBCustomers_id ON DBCustomers -- use this if clustered index already exists.
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON DBCustomers

-- creating non-clustered columnstore index. NOTE: SQL Server does not allow more than one columnstore index
-- DROP INDEX idx_DBCustomers_CS ON DBCustomers
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON DBCustomers(customerName)