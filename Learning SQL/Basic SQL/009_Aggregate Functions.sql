-- Aggregate functions
USE MySalesDB

-- A quick view of table
SELECT * FROM orders

-- COUNT function returns totoal number of records
-- Task: find total number of customers
SELECT COUNT(*) AS total_number FROM orders


-- SUM function returns sum of all numbers in a column
-- Task: find sum of total amount
SELECT SUM(amount) AS total_amount FROM orders


-- AVG function returns average of all numbers in a column
-- Task: find average of amount
SELECT AVG(amount) AS avg_amount FROM orders


-- MAX function returns max value in a column
-- Task: find max amount
SELECT MAX(amount) AS max_amount FROM orders


-- MIN function returns min value in a column
-- Task: find min amount
SELECT MIN(amount) AS min_amount FROM orders


SELECT
	COUNT(*) AS total_number,
	SUM(amount) AS total_amount,
	AVG(amount) AS avg_amoun,
	MAX(amount) AS max_amount,
	MIN(amount) AS min_amount
FROM orders