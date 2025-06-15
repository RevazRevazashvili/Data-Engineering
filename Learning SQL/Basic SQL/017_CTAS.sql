-- OPTIMIZATIONS
-- CTAS - Create Table As Select
USE MySalesDB

/*
	CTAS is another optimization approach for quering the data from a DB
	unlike a VIEW, it creates a static table that runs only once and the 
	result set will be the same even we query next time(days, months, etc)
	It is faster than a VIEW.
*/

SELECT
	DATENAME(month, orderDate) orderMonth,
	COUNT(orderID) totalOrders
INTO MonthlyOrders
FROM orders
GROUP BY orderDate

-- we can select the data as selecting regular table
SELECT * FROM MonthlyOrders

-- Dropping the CTAS table
DROP TABLE MonthlyOrders

-- To refresh the CTAS we can use T-SQL
IF OBJECT_ID('MonthlyOrders', 'U') IS NOT NULL -- 'U' stands for user-defined table
	DROP TABLE MonthlyOrders;
GO
SELECT
	DATENAME(month, orderDate) orderMonth,
	COUNT(orderID) totalOrders
INTO MonthlyOrders
FROM orders
GROUP BY orderDate