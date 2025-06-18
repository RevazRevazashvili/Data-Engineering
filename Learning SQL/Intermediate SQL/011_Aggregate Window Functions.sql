-- Aggregate Window Functions
USE MySalesDB

SELECT * FROM orders

-- COUNT function in window function
/*
	The best use cases and examples
	use cases:
		Overall Analysis
		Category Analysis
		Quality Checks: Identify NULLs
		Quality Checks: Identify Duplicates
*/
-- Task: find total number of orders for each customers
SELECT
	orderID,
	orderDate,
	customerID,
	COUNT(*) OVER() totalOrders,
	COUNT(*) OVER(PARTITION BY customerID) totalOrdersByCustomers
FROM orders

-- in count function * and 1 works similar
SELECT
	orderID,
	orderDate,
	customerID,
	COUNT(1) OVER() totalOrders,
	COUNT(1) OVER(PARTITION BY customerID) totalOrdersByCustomers
FROM orders


-- check whether the table orders contains duplicates or not
-- in this case we dont have duplicates, however this query works correct about finding duplicates
SELECT * FROM(
	SELECT
	orderID,
	COUNT(*) OVER(PARTITION BY orderID) AS totalNum
	FROM orders
)t WHERE totalNum > 1


-- SUM function in window function
/*
	The best use cases and examples
	use cases:
		Overall Analysis
		Total per groups
		Part-To-Whole
*/
-- Task: find the total sales acroll all orders and the total
-- sales for each product. Additionally provide details such
-- as order ID and order date
SELECT
	orderID,
	orderDate,
	SUM(amount) OVER() totalSum,
	SUM(amount) OVER(PARTITION BY productsID) totalSumForEachProduct
FROM orders


-- Task: find the percentage contribution of each product's
-- sales to the total sales
SELECT
	orderID,
	orderDate,
	amount,
	SUM(amount) OVER() totalSum,
	ROUND(CAST(amount AS FLOAT)/SUM(amount) OVER()*100, 2) AS percentage
FROM orders


-- AVG function in window function
/*
	The best use cases and examples
	use cases:
		Overall Analysis
		Total per groups
		Compare To Average
*/
--Task: find the average sales acroll all orders and 
-- the average sales for each product. Additionally, provide
-- details such as order ID and order date
SELECT
	orderID,
	orderDate,
	amount,
	AVG(amount) OVER() AS averageTotal,
	AVG(amount) OVER(PARTITION BY productsID) AS averageTotalPerProduct
FROM orders


-- Task: find the average scores of customers. Additionally
-- provide details such as order ID and order date
SELECT
	id,
	customerName,
	customersurname,
	salary,
	AVG(salary) OVER() AS averageTotalPerCustomer,
	AVG(COALESCE(salary, 0)) OVER() AS averageTotalPerCustomer2 -- if we don't handle null values the output will be wrong
FROM customers


-- Task: find all orders where sales are higher than the
-- average sales across all orders
SELECT
*
FROM
(
SELECT
	orderID,
	orderDate,
	amount,
	AVG(amount) OVER() avgSales
FROM orders
)t WHERE amount > avgSales


-- MIN and MAX functions in window function
/*
	The best use cases and examples
	use cases:
		Overall Analysis
		MIN(MAX) per groups
		Compare To Extremes
*/
-- Task: find the highest & lowest sales across all orders
-- find the highest & lowest sales across all orders
-- Additionally, provide details such as order ID and order date
SELECT
	orderID,
	orderDate,
	amount,
	productsID,
	MIN(amount) OVER() AS minSales,
	MAX(amount) OVER() AS maxSales,
	MIN(amount) OVER(PARTITION BY productsID) AS minSalesPerProduct,
	MAX(amount) OVER(PARTITION BY productsID) AS maxSalesPerProduct
FROM orders


-- Task: calculate the deviation of each sale from
-- both the minimum and maximum sales amounts
SELECT
	orderID,
	orderDate,
	amount,
	productsID,
	MIN(amount) OVER() AS minSales,
	MAX(amount) OVER() AS maxSales,
	amount - MIN(amount) OVER() AS deviationFromMin,
	MAX(amount) OVER() - amount AS deviationFromMax
FROM orders


-- Running & Rolling total & Moving Average --
-- Running total
SELECT
	orderID,
	orderDate,
	amount,
	productsID,
	SUM(amount) OVER(ORDER BY orderDate ROWS BETWEEN
	UNBOUNDED PRECEDING AND CURRENT ROW) AS runningTotal
FROM orders

-- Rolling total
SELECT
	orderID,
	orderDate,
	amount,
	productsID,
	SUM(amount) OVER(ORDER BY orderDate ROWS BETWEEN
	2 PRECEDING AND CURRENT ROW) AS runningTotal
FROM orders


-- Moving Average
SELECT
	orderID,
	orderDate,
	amount,
	productsID,
	AVG(CAST(amount AS FLOAT)) OVER(PARTITION BY productsID ORDER BY orderDate ROWS BETWEEN
	2 PRECEDING AND CURRENT ROW) AS moovingAverage
FROM orders