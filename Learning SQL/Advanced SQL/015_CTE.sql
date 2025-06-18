-- OPTIMIZATIONS
-- CTE - Common Table Expression
USE MySalesDB

/*
	Common Table Expression is temporary, named result set(virtual table)
	that can be used multiple times within your query to simplify
	and organize complex query.
	CET creates a temporary table that we can use many times in a query.
	it is the most important difference from Subquery that is also generates an
	intermediate table but it is used only once.
	Another difference between these two techniques is executing order.
	In Subquery queries execute from bottom to top(first subquery and next main query)
	On the other hand - CTE executes from top to bottom, but top query is not
	a main query.
	CTE has two major types: None-Recursive CTE, Recursive CTE.
	None-Recursive CTE has two sub-types: Standalone CTE and Nested CTE.

*/


-- Standalone CTE - Defined and used independently
-- Runs independently as it's self-contained and does not rely
-- on other CTEs or queries.
-- Multiple Standalone CTE - when we use more than one CTE in our query
-- it's multiple CTEs.
-- Task: #Step1. find the total sales per customer
WITH CTE_totalSales AS(
SELECT
	customerID,
	SUM(amount) AS totalSales
FROM orders
	GROUP BY customerID
),
-- #Step2: find the last order date for each customer
CTE_lastOrder AS(
SELECT
	customerID,
	MAX(orderDate) AS lastOrder
FROM orders
GROUP BY customerID
),
-- #Step3: rank customers based on total sales per customer(Nested CTE)
CTE_customerRank AS
(
SELECT
customerID,
totalSales,
RANK() OVER(ORDER BY totalSales DESC) AS customerRank
FROM CTE_totalSales
),
-- #Stemp4: segment customers based on their total sales(Nested CTE)
CTE_customerSegment AS
(
SELECT
customerID,
CASE WHEN totalSales > 10 THEN 'High'
	 WHEN totalSales > 5 THEN 'Medium'
	 ELSE 'Low'
END AS segment
FROM CTE_totalSales
)
-- Main Query
SELECT
	c.id,
	c.customerName,
	c.customersurname,
	cts.totalSales,
	ctsl.lastOrder,
	ctsc.customerRank,
	ctscc.segment
FROM customers c
LEFT JOIN CTE_totalSales cts
ON c.id=cts.customerID
LEFT JOIN CTE_lastOrder ctsl
ON c.id=ctsl.customerID
LEFT JOIN CTE_customerRank ctsc
ON c.id=ctsc.customerID
LEFT JOIN CTE_customerSegment ctscc
ON c.id=ctscc.customerID


-- Recursive CTE - CTE that calls itself in the CTE is called recursive cte.
-- Task: generate a sequence of numbers from 1 to 20
WITH Series AS(
-- Anchor query
	SELECT
		1 AS myNumber
	UNION ALL
	SELECT myNumber+1 FROM Series
	WHERE myNumber!=20
)
-- Main query
SELECT * FROM Series


-- Task: show the employee hierarchy by displaying each employee's
-- level within the organization
WITH CTE_empHierarchy AS
(
	--Achor Query
	SELECT
		employeeID,
		employeeName,
		managerID,
		1 AS level
	FROM employee
	WHERE managerID IS NULL
	UNION ALL
	-- Recursive Query
	SELECT
		e.employeeID,
		e.employeeName,
		e.managerID,
		level + 1
	FROM employee e
	INNER JOIN CTE_empHierarchy ceh
	ON e.managerID=ceh.employeeID
)
SELECT
*
FROM CTE_empHierarchy