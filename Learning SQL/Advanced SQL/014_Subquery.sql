-- OPTIMIZATIONS
-- Subquery
USE MySalesDB


/*
	A subquery is a query inside another query.
	Result type of subqueries: 
	Scalar Subquery - a query thet returns a single value,
	Row Subquery - a query that returns multiple rows but single column,
	Table Subquery - a query that returns multiple rows and multiple columns.
	
	A subquery maybe used in SELECT, FROM, JOIN and WHERE.

	NOTE: subquery result is been stored in cache memory for faster retrieval.

*/
-- Subquery in FROM clause
-- Task: find the products that have a price higher than the average
-- price of all products

-- Main query
SELECT
*
-- Subquery
FROM(
	SELECT
	*,
	AVG(price) OVER() avgPrice
	FROM products
) AS t WHERE price > avgPrice

-- Task: rank customers base on their total amount of sales
SELECT
*,
RANK() OVER(ORDER BY totalSales DESC) AS rankBySales
FROM(
	SELECT
	customerID,
	SUM(amount) AS totalSales
	FROM orders
	GROUP BY customerID
) AS t


-- Subqurey in SELECT command
-- NOTE: when using subqery in SELECT, it must return only a scalar value. Otherwise error arises
-- Task: show the product IDs, names, prices and total number of order
SELECT
	productID,
	productName,
	price,
	(SELECT COUNT(*) FROM products) AS totalOrders
FROM products


-- Subqurey in JOINS
-- Task: show all customer details and fined total orders for each customer.
SELECT
c.*,
o.totalOrders
FROM customers c
LEFT JOIN(
	SELECT
	customerID,
	COUNT(*) totalOrders
	FROM orders
	GROUP BY customerID) o
ON c.id=o.customerID


-- Subquery in WHERE clause
-- Task: find the products that have a price higher than the 
-- average price of all products
SELECT
*
FROM products
WHERE price > (SELECT AVG(price) FROM products)

-- Task: show the details of orders made by male customers.
SELECT
*
FROM orders
WHERE customerID IN (SELECT id FROM customers WHERE gender='M')

-- Task: show the details of orders made by not male customers.
SELECT
*
FROM orders
WHERE customerID NOT IN (SELECT id FROM customers WHERE gender='M')


-- ANY & ALL operators
-- Task: find female employees whose salaries are greater than the salaries of any 
-- male employees.
SELECT
*,
CAST(workingHours * hourlySalary AS INT) AS salary
FROM employee
WHERE gender='F' AND CAST(workingHours * hourlySalary AS INT) > ANY
(SELECT CAST(workingHours * hourlySalary AS INT) FROM employee WHERE gender='M')


-- Task: find female employees whose salaries are greater
-- than the salaries of all male employees.
SELECT
*,
CAST(workingHours * hourlySalary AS INT) AS salary
FROM employee
WHERE gender='F' AND CAST(workingHours * hourlySalary AS INT) > ALL
(SELECT CAST(workingHours * hourlySalary AS INT) FROM employee WHERE gender='M')



-- NON-Correlated Subquery
-- A subquery that can run independently from the main query.
-- NON-Correlated Subquery executes only once and the result is 
-- stored in cache memory.
-- ALL above subqueries were non-correlated.

-- Correlated Subquery
-- A subquery that relays on value from the main query.
-- correlated subquery is executed for each row, processed by main query
-- Task: show all customer details and find the total orders
-- for each customer
SELECT 
*,
(SELECT COUNT(*) FROM orders o 
WHERE o.customerID = c.id
) AS totalOrders
FROM customers c


-- EXISTS Operator
-- Exists check if a subquery returns any rows.
-- Task: show the details of orders made by male customers.
SELECT
*
FROM orders o
WHERE EXISTS(
		SELECT 1
		FROM customers c
		WHERE gender='M'
		AND o.customerID=c.id)

-- Task: show the details of orders made by not male customers.
SELECT
*
FROM orders o
WHERE NOT EXISTS(
		SELECT 1
		FROM customers c
		WHERE gender='M'
		AND o.customerID=c.id)