-- Value Window Functions or Analytical Window Functions
USE MySalesDB

-- LAG Function is used to retrieve previous record of the current row
-- Task: Analyze the day-over-day performance by finding the percentage
-- change in sales between the current and previous days
SELECT
*,
ISNULL(currentMonthSales, 0) - ISNULL(previousMonthSales, 0) AS MoN_Change,
ROUND(CAST((currentMonthSales - previousMonthSales) AS FLOAT)/previousMonthSales * 100, 1) AS percentage
FROM(
SELECT
	MONTH(orderDate) orderMonth,
	SUM(amount) currentMonthSales,
	LAG(SUM(amount)) OVER(ORDER BY MONTH(orderDate)) previousMonthSales
FROM orders
GROUP BY 
	MONTH(orderDate)
)t


-- Task: Analyze customer loyalty by ranking customers based on the average
-- number of days between orders
SELECT
customerID,
AVG(daysUntilNextOrder) avgDays,
RANK() OVER(ORDER BY COALESCE(AVG(daysUntilNextOrder), 999999)) rankAverage
FROM(
SELECT
	orderID,
	customerID,
	orderDate AS currentOrder,
	LEAD(orderDate) OVER(PARTITION BY customerID ORDER BY orderDate) AS nextOrder,
	DATEDIFF(day, orderDate, LEAD(orderDate) OVER(PARTITION BY customerID ORDER BY orderDate)) AS daysUntilNextOrder
FROM orders)t
GROUP BY customerID


-- FIRST_VALUE & LAST_VALUE Functions
-- both function have the very straightforward functionality
-- first value returns first value in a sequence and last value - last
-- Task: Find the lowest and highest sales for each product
SELECT
*,
FIRST_VALUE(amount) OVER(PARTITION BY productsID ORDER BY amount) AS firstValue,
LAST_VALUE(amount) OVER(PARTITION BY productsID ORDER BY amount 
						ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS lastValue
FROM orders
