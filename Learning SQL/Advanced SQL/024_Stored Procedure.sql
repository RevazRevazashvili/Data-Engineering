-- Stored Procedure
USE MySalesDB


/*
	A Stored Procedure is a way to save the same SQL statements(select, insert, update...)
	in a procedure and every time you need those particular things to do, you
	will run procedure and you won't need to write the same SQL queries for every time.
	Unlike the normal query a Stored procedure may contain more than one SQL statements

*/

-- Step 1: write a query
-- for male customers find the total number of customers and the average score
SELECT
	COUNT(*) AS totalNum,
	AVG(salary) AS avgSalary
FROM customers
WHERE gender = 'M'

-- Step 2: turning the query into a stored procedure
CREATE PROCEDURE getCustomerSummary AS
BEGIN
SELECT
	COUNT(*) AS totalNum,
	AVG(salary) AS avgSalary
FROM customers
WHERE gender = 'M'
END

-- Step 3: execute the stored procedure
EXEC getCustomerSummary


/*
	Parameters are placeholders used to pass values as input from the caller
	to the procedure, allowing dynamic data to be processed.
*/

-- to create a stored procedure with parameters you need to follow this step
CREATE PROCEDURE getCustomerSummaryWithParameters @gender char
AS
BEGIN
SELECT
	COUNT(*) AS totalNum,
	AVG(salary) AS avgSalary
FROM customers
WHERE gender = @gender
END

-- run procedure
EXEC getCustomerSummaryWithParameters @gender='F'

EXEC getCustomerSummaryWithParameters @gender='M'

-- to delete the procedure you have to use drop
DROP PROCEDURE getCustomerSummary


-- you can define a default values
ALTER PROCEDURE getCustomerSummaryWithParameters @gender char = 'M' -- default value will be male
AS
BEGIN
SELECT
	COUNT(*) AS totalNum,
	AVG(salary) AS avgSalary
FROM customers
WHERE gender = @gender
END

EXEC getCustomerSummaryWithParameters

EXEC getCustomerSummaryWithParameters @gender='F'


-- We can also put another query in one procedure
ALTER PROCEDURE getCustomerSummaryWithParameters @gender char = 'M' -- default value will be male
AS
BEGIN
SELECT
	COUNT(*) AS totalNum,
	AVG(salary) AS avgSalary
FROM customers
WHERE gender = @gender;

-- find the total number of orders and total sales
SELECT
COUNT(orderID) totalOrders,
SUM(amount) totalSales
FROM orders o
JOIN customers c
ON o.customerID=c.id
WHERE c.gender= @gender
END

EXEC getCustomerSummaryWithParameters


-- VARIABLES into stored procedure
ALTER PROCEDURE getCustomerSummaryWithParameters @gender char = 'M'
AS
BEGIN

	DECLARE @totalNum INT, @avgSalary FLOAT;

	SELECT
		@totalNum = COUNT(*),
		@avgSalary = AVG(salary)
	FROM customers
	WHERE gender = @gender;

	PRINT 'total number of customers '+ CAST(@totalNum AS NVARCHAR)+' average salary '+ CAST(@avgSalary AS NVARCHAR)

	-- find the total number of orders and total sales
	SELECT
		COUNT(orderID) totalOrders,
		SUM(amount) totalSales
	FROM orders o
	JOIN customers c
	ON o.customerID=c.id
	WHERE c.gender= @gender
END

EXEC getCustomerSummaryWithParameters


-- Control flow IF ELSE
ALTER PROCEDURE getCustomerSummaryWithParameters @gender char = 'M'
AS
BEGIN

	DECLARE @totalNum INT, @avgSalary FLOAT;

	-- Prepare and cleanup data
	IF EXISTS (SELECT 1 FROM customers WHERE salary IS NULL AND gender = @gender)
	BEGIN
	PRINT('Updating the salary to 0');
		UPDATE customers
		SET salary = 0
		WHERE salary IS NULL AND gender = @gender
	END

	ELSE
	BEGIN
		PRINT('No NULL value found');
	END

	-- Generating report
	SELECT
		@totalNum = COUNT(*),
		@avgSalary = AVG(salary)
	FROM customers
	WHERE gender = @gender;

	PRINT 'total number of customers '+ CAST(@totalNum AS NVARCHAR)+' average salary '+ CAST(@avgSalary AS NVARCHAR)

	-- find the total number of orders and total sales
	SELECT
		COUNT(orderID) totalOrders,
		SUM(amount) totalSales
	FROM orders o
	JOIN customers c
	ON o.customerID=c.id
	WHERE c.gender= @gender
END

EXEC getCustomerSummaryWithParameters

EXEC getCustomerSummaryWithParameters @gender = 'F'



-- Error Handling - Try Catch
ALTER PROCEDURE getCustomerSummaryWithParameters @gender char = 'M'
AS
BEGIN
	BEGIN TRY
		DECLARE @totalNum INT, @avgSalary FLOAT;
		-- ========================
		-- Prepare and cleanup data
		-- ========================
		IF EXISTS (SELECT 1 FROM customers WHERE salary IS NULL AND gender = @gender)
		BEGIN
			PRINT('Updating the salary to 0');
			UPDATE customers
			SET salary = 0
			WHERE salary IS NULL AND gender = @gender
		END

		ELSE
		BEGIN
			PRINT('No NULL value found');
		END
		-- =================
		-- Generating report
		-- =================
		SELECT
			@totalNum = COUNT(*),
			@avgSalary = AVG(salary)
		FROM customers
		WHERE gender = @gender;

		PRINT 'total number of customers '+ CAST(@totalNum AS NVARCHAR);
		PRINT('average salary '+ CAST(@avgSalary AS NVARCHAR));

		-- ===============================================
		-- find the total number of orders and total sales
		-- ===============================================
		SELECT
			COUNT(orderID) totalOrders,
			SUM(amount) totalSales
		FROM orders o
		JOIN customers c
		ON o.customerID=c.id
		WHERE c.gender= @gender
	END TRY
	-- =================
	-- An error Handling
	-- =================
	BEGIN CATCH
		PRINT('An error occured.');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH
END

EXEC getCustomerSummaryWithParameters

