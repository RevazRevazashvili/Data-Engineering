-- OPTIMIZATIONS
-- Temp Tables - Temporary Tables
USE MySalesDB

/*
	Temp Tables stores intermediate results in temporary storage within
	the database during the session.
	The database will drop all temporary tables once the session ends.
*/

-- creating temporary table(you have to use # before table name)
SELECT 
*
INTO #orders
FROM orders

-- you can modify temp tables as you want(select, delete, update, etc)
DELETE FROM #orders
WHERE orderStatus='Delivered'

-- updating temp table's record
UPDATE #orders SET orderStatus='Delivered'
WHERE orderID=5

-- selecting data from the temp table
SELECT * FROM #orders

-- save intermediate result back in the Database.
IF OBJECT_ID('ordersTest', 'U') IS NOT NULL
	DROP TABLE ordersTest;
GO
SELECT
*
INTO ordersTest
FROM #orders
