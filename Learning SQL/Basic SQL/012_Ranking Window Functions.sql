-- Ranking Window Functions

USE MySalesDB


-- TOP/BOTTOM N Analysis
-- ROW_NUMBER function will asign unique ranks to records
-- if even there are duplicates. function needs ordered sequence
-- Task: Rank the orders based on their sales
-- from highest to lowest
SELECT
*,
ROW_NUMBER() OVER(ORDER BY amount DESC) as rank
FROM orders


-- RANK function will asign ranks to records but the same
-- records will have the same rank. Rank function also skips the rank
-- if the two or more record have the same value. function needs ordered sequence.
-- Task: Rank the orders based on their sales
-- from highest to lowest
SELECT
*,
ROW_NUMBER() OVER(ORDER BY amount DESC) as rowNumberRank,
RANK() OVER(ORDER BY amount DESC) as rank
FROM orders


-- DENSE_RANK function will asign ranks to records but the same
-- records will have the same rank. function needs ordered sequence.
-- Task: Rank the orders based on their sales
-- from highest to lowest
SELECT
	orderID,
	customerID,
	amount,
	ROW_NUMBER() OVER(ORDER BY amount DESC) as rowNumberRank,
	RANK() OVER(ORDER BY amount DESC) as rank,
	DENSE_RANK() OVER(ORDER BY amount DESC) as denseRank
FROM orders


-- TOP-N-ANALYSIS
-- Task: find the top highest sales for each product
SELECT
	orderID,
	customerID,
	amount,
	rankEachProduct
FROM(
SELECT
	orderID,
	customerID,
	amount,
	ROW_NUMBER() OVER(PARTITION BY productsID ORDER BY amount DESC) AS rankEachProduct
FROM orders
)t WHERE rankEachProduct = 1


-- BOTTOM-N-ANALYSIS
-- Task: find the lowest 2 customers on their total sales
SELECT
*
FROM(
SELECT
	customerID,
	SUM(amount) totalForPerCustomer,
	ROW_NUMBER() OVER(ORDER BY SUM(amount)) rankCustomers
FROM orders
GROUP BY customerID
)t WHERE rankCustomers <= 2


-- Task: identify duplicate rows in the table orders and return a clean
-- result without any duplicate
SELECT
	*
FROM
(
	SELECT
		orderID,
		customerID,
		ROW_NUMBER() OVER(PARTITION BY orderID ORDER BY orderDate) AS uniqueOrders
	FROM orders
)t WHERE uniqueOrders = 1
-- duplicate data would be
SELECT
	*
FROM
(
	SELECT
		orderID,
		customerID,
		ROW_NUMBER() OVER(PARTITION BY orderID ORDER BY orderDate) AS uniqueOrders
	FROM orders
)t WHERE uniqueOrders > 1


-- NTILE function will asign ranks to records. it splits entire dataset into buckets
-- bucket will be calculated as follows bucket=number of rows/NTILE(n)
-- function needs ordered sequence.
-- Task: Rank the orders based on their sales
-- from highest to lowest
SELECT
	orderID,
	amount,
	NTILE(1) OVER(ORDER BY amount DESC) oneBucket,
	NTILE(2) OVER(ORDER BY amount DESC) twoBucket,
	NTILE(3) OVER(ORDER BY amount DESC) threeBucket,
	NTILE(5) OVER(ORDER BY amount DESC) fourBucket
FROM orders

-- USE CASES of NTILE
-- for analysts
-- Task: segment all orders into 3 categories: high, medium, low sales
SELECT
	orderID,
	amount,
CASE
	WHEN threeBuckets=1 THEN 'High'
	WHEN threeBuckets=2 THEN 'Medium'
	ELSE 'Low'
END AS category
FROM(
SELECT
	orderID,
	amount,
	NTILE(3) OVER(ORDER BY amount DESC) AS threeBuckets
FROM orders
)t

--LOAD Balancing. for data engineers
-- Task: in order to export the data, divide the orders into 2 groups
SELECT
NTILE(2) OVER(ORDER BY orderID) as Buckets,
*
FROM orders


-- Distribution Analysis
-- CUME_DIST
-- Cumulative Distribution calculates the distribution of data points within a window.
-- order by is must.
-- CUME_DIST=position number/number of rows
-- Task: find the products that fall within the highest 40% of prices
SELECT
*,
CONCAT(cumedist*100, '%') cumedistPercentage
FROM(
	SELECT
		*,
		CUME_DIST() OVER(ORDER BY price) AS cumedist
	FROM products
)t WHERE cumedist>=0.4


-- PERCENT_RANK
-- percent rank calculates the relative position of each row.
-- CUME_DIST=position number -1 /number of rows -1
-- Task: find the products that fall within the highest 40% of prices.
SELECT
*,
CONCAT(ROUND(percentRank*100, 2), '%') percentRankPercentage
FROM(
	SELECT
		*,
		PERCENT_RANK() OVER(ORDER BY price) AS percentRank
	FROM products
)t WHERE percentRank > 0.4