-- sored procedure to list all the indexes on a specific table
sp_helpindex 'dbo.DBCustomers'


-- Monitoring Index Usage

SELECT
	tbl.object_id,
	idx.name AS indexName,
	idx.type_desc AS indexType,
	idx.is_primary_key AS isPrimaryKey,
	idx.is_unique AS isUnique,
	idx.is_disabled AS isDisabled,
	s.user_seeks,
	s.user_scans,
	s.user_lookups,
	s.user_updates,
	COALESCE(s.last_user_seek, s.last_user_scan) lastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id=tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id=idx.object_id
AND s.index_id=idx.index_id


-- Monitor missing indexes.
SELECT
	*,
	c.customerName,
	c.salary
FROM orders o
INNER JOIN customers c
ON o.customerID=c.id

SELECT * FROM sys.dm_db_missing_index_details


-- Monitor duplicate indexes
SELECT
	tbl.name AS tableName,
	col.name AS indexColumn,
	idx.name AS indexName,
	idx.type_desc AS indexType,
	COUNT(*) OVER(PARTITION BY tbl.name, col.name) columnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id=tbl.object_id
JOIN sys.index_columns ic ON idx.object_id=ic.object_id AND idx.index_id=ic.index_id
JOIN sys.columns col ON ic.object_id=col.object_id AND ic.column_id=col.column_id
ORDER BY columnCount


-- Update statistics
-- Analyze statistics first
SELECT
	SCHEMA_NAME(t.schema_id) AS schemaName,
	t.name AS tableName,
	s.name AS statsName,
	sp.last_updated AS lastUpdated,
	DATEDIFF(day, sp.last_updated, GETDATE()) AS lastUpdateDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS modificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t
ON s.object_id=t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY sp.modification_counter DESC

-- actual update
UPDATE STATISTICS orders _WA_Sys_00000007_3B75D760

-- to update an entire table statistics we just write as below
UPDATE STATISTICS orders

-- to update an entire database stats then we use special store procedure as below
EXEC sp_updatestats