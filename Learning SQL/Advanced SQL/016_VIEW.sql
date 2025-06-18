-- OPTIMIZATIONS
-- Views
USE MySalesDB

/*
	View is a virtual table that shows data without storing it physically.
	Views are persisted queries in the database.
	How it works - every View has attached a SQL query that retrievs the data
	from a physical table and every query that communicates with view, reruns
	the attached query of the view.
*/

-- Task: find the running total of sales for each month.
WITH CTE_runningTotal AS (
	SELECT
	DATETRUNC(month, orderDate) AS month,
	SUM(amount) AS total,
	COUNT(customerID) AS totalOrders
	FROM orders
	GROUP BY DATETRUNC(month, orderDate)
)
SELECT
month,
total,
totalOrders,
SUM(total) OVER(ORDER BY month) AS runningTotal
FROM CTE_runningTotal

/*
	What if this logic is very demanding and needs evryone?
	SELECT
	DATETRUNC(month, orderDate) AS month,
	SUM(amount) AS total,
	COUNT(customerID) AS totalOrders
	FROM orders
	GROUP BY DATETRUNC(month, orderDate)

	With CTE we can not use it in multiple SQL queries from multiple projects
	for this reason we can create a VIEW.
*/

CREATE VIEW V_Monthly_Summary AS (
	SELECT
	DATETRUNC(month, orderDate) AS month,
	SUM(amount) AS total,
	COUNT(customerID) AS totalOrders
	FROM orders
	GROUP BY DATETRUNC(month, orderDate)
)


-- Same task with view find the running total of sales for each month.
SELECT
month,
total,
SUM(total) OVER(ORDER BY month) AS runningTotal
FROM V_Monthly_Summary


-- Dropping the VIEW
DROP VIEW V_Monthly_Summary


-- Updating the view with T-SQL - Transact-SQL
IF OBJECT_ID('V_Monthly_Summary', 'V') IS NOT NULL
	DROP VIEW V_Monthly_Summary;
GO
CREATE VIEW V_Monthly_Summary AS (
	SELECT
	DATETRUNC(month, orderDate) AS month,
	SUM(amount) AS total,
	COUNT(customerID) AS totalOrders
	FROM orders
	GROUP BY DATETRUNC(month, orderDate)
)


-- Task: provide a view that combines details from
-- orders, products, customers and employees.
CREATE VIEW V_Order_Details AS (
	SELECT
		o.orderID,
		o.orderDate,
		o.orderStatus,
		o.amount,
		p.productName,
		p.price,
		c.customerName + ' ' + c.customersurname AS customerName,
		c.gender,
		c.salary,
		e.employeeName,
		e.managerID,
		e.hourlySalary*e.workingHours AS employeeSalary
	FROM orders AS o
	LEFT JOIN products p
	ON o.customerID=p.productID
	LEFT JOIN customers c
	ON o.customerID=c.id
	LEFT JOIN employee e
	ON o.customerID=e.employeeID
)


/* 
	VIEWS are good way to protect data. Instead of direct access from
	any users to the table, you can provide them a view with only columns
	you want to see them
*/
-- Task: provide a view for the male sales team that combines
-- details from all tables and excludes data related to female.
CREATE VIEW V_Order_Details_Male AS(
	SELECT
		o.orderID,
		o.orderDate,
		o.orderStatus,
		o.amount,
		p.productName,
		p.price,
		c.customerName + ' ' + c.customersurname AS customerName,
		c.gender,
		c.salary,
		e.employeeName,
		e.managerID,
		e.hourlySalary*e.workingHours AS employeeSalary
	FROM orders AS o
	LEFT JOIN products p
	ON o.customerID=p.productID
	LEFT JOIN customers c
	ON o.customerID=c.id
	LEFT JOIN employee e
	ON o.customerID=e.employeeID
	WHERE c.gender='M'
)
