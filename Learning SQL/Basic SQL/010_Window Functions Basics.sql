-- Window functions
/*
	Window functions are another way to make calculations on a subset of a table
	it is very similar to GROUP BY that groups up data and makes a calculation
	for	similar data as a group. Unlike group by, window functions make calculations
	for each row and that way the rows are not missing, if there is 4 records
	after window function there is still 4 records in output but with group by 
	there will be only the distinct records and each record contains aggregated
	information of similar records with columns grouped by.
	Also, window functions have more functions to aggregate and make
	an analyzes than group by.
*/

USE MySalesDB

-- A quick check of the table
SELECT * FROM orders

-- PARTITION BY
SELECT
customerID,
SUM(amount) OVER(PARTITION BY customerID) AS totalSales -- window function to summurize total sales for each row
FROM orders

-- we could also use more than one values in partition by clause
SELECT
orderID,
customerID,
orderDate,
amount,
SUM(amount) OVER(PARTITION BY customerID, orderDate) AS totalSales
FROM orders


-- ORDER BY into window
-- Task: Rank each order based on their sales from highest
-- to lowest, Additionally provide details such
-- order id, order date
SELECT
	orderID,
	orderDate,
	amount,
	RANK() OVER(ORDER BY amount DESC) AS rankHighestToLowest
FROM orders


--WINDOW FRAME
-- NOTE: window frame always need order by into OVER()
select * from orders

-- the following code will do...
/*
	entire dataset will be splitted by order status(delivered, shipped in this case)
	we will get windows one for each status, then each window will be ordered by date
	and then summurization will be performed such as current row and 2 following row
*/
SELECT
orderID,
orderDate,
orderStatus,
amount,
SUM(amount) OVER(PARTITION BY orderStatus ORDER BY orderDate
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) totalSales
FROM orders


-- INTERESTING CASE --
-- Task: Rank customers based on their total sales
SELECT
	customerID,
	SUM(amount) totalSales,
	RANK() OVER(ORDER BY SUM(amount) DESC) rankCustomers
FROM orders
GROUP BY customerID
/*
	what we have interesting in above example. generally, we cannot use groub by 
	and window functions together unless we use the same column in both group by and windowing
	in this case we use amount in both group by and windowing.
	!!! RANK function is used on summed amount column 
*/