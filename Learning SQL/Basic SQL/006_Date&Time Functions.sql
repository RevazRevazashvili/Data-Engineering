-- Date and Time functions

USE MySalesDB

-- Part Extraction functions

-- Extracting a day from date
SELECT TOP 1 orderDate, DAY(orderDate) AS date_day FROM orders

-- Extracting a month from date
SELECT TOP 1 orderDate, MONTH(orderDate) AS date_month FROM orders

-- Extracting a year from date
SELECT TOP 1 orderDate, YEAR(orderDate) AS date_year FROM orders


-- Datepart function returns specific part of a datetime
SELECT TOP 1 
	orderDate, 
	DATEPART(MONTH, orderDate) AS date_month,
	DATEPART(DAY, orderDate) AS date_day,
	DATEPART(YEAR, orderDate) AS date_year,
	DATEPART(WEEK, orderDate) AS date_week,
	DATEPART(QUARTER, orderDate) AS date_quarter
FROM orders


-- Datename function returns specific part of a datetime in word format
SELECT TOP 1 
	orderDate, 
	DATENAME(MONTH, orderDate) AS date_month,
	DATENAME(WEEKDAY, orderDate) AS date_day
FROM orders


-- Datetrunc function returns specific part of a datetime truncated on the specific part.
SELECT
	GETDATE(), 
	DATETRUNC(YEAR, GETDATE()) AS date_year,
	DATETRUNC(MONTH, GETDATE()) AS date_month,
	DATETRUNC(DAY, GETDATE()) AS date_day,
	DATETRUNC(HOUR, GETDATE()) AS date_week,
	DATETRUNC(MINUTE, GETDATE()) AS date_quarter


-- EOMONTH is function that will return date with last day of the month.
SELECT
	GETDATE(), 
	EOMONTH(GETDATE()) AS current_months_last_date


-- format and casting functions

-- FORMAT is the function that help us to format date or numbers.
SELECT
	orderDate,
	FORMAT(orderDate, 'dd-MM-yyyy'),
	FORMAT(orderDate, 'dddd MMMM yyyy'),
	FORMAT(orderDate, 'dd') dd,
	FORMAT(orderDate, 'ddd') ddd,
	FORMAT(orderDate, 'dddd') dddd,
	FORMAT(orderDate, 'MM') MM,
	FORMAT(orderDate, 'MMM') MMM,
	FORMAT(orderDate, 'MMMM') MMMM,
	FORMAT(orderDate, 'yy') yy,
	FORMAT(orderDate, 'yyyy') yyyy
FROM orders


-- total orders by month
SELECT
	FORMAT(orderDate, 'MMM yyyy') month,
	COUNT(*) orders_count
FROM orders
GROUP BY FORMAT(orderDate, 'MMM yyyy')


-- total orders by year
SELECT
	FORMAT(orderDate, 'yyyy') month,
	COUNT(*) orders_count
FROM orders
GROUP BY FORMAT(orderDate, 'yyyy')


-- CONVERT functions converts one type of data into another
SELECT 
CONVERT(INT, '123') [string to int],
CONVERT(DATE, '2025-02-12') [string to date]


-- CAST is the function to cast one type of data into another
SELECT 
CAST('123' AS INT) [string to int],
CAST(123 AS VARCHAR) [int to string],
CAST(GETDATE() AS INT) [datetime to int],
CAST(GETDATE() AS DATE) [datetime to date],
CAST(GETDATE() AS VARCHAR) [datetime to string]



-- calculation functions

SELECT
orderDate,
DATEADD(YEAR, 2, orderDate) AS two_years_later,
DATEADD(YEAR, -2, orderDate) AS two_years_earlier,
DATEADD(MONTH, 2, orderDate) AS two_month_later,
DATEADD(MONTH, -2, orderDate) AS two_month_earlier,
DATEADD(DAY, 2, orderDate) AS two_day_later,
DATEADD(DAY, -2, orderDate) AS two_day_earlier
FROM orders


SELECT
orderDate,
DATEDIFF(YEAR, orderDate, DATEADD(YEAR, 1, orderDate)) AS [parcel arrives in years],
DATEDIFF(MONTH, orderDate, DATEADD(MONTH, 13, orderDate)) AS [parcel arrives in monthes],
DATEDIFF(DAY, orderDate, DATEADD(MONTH, 14, orderDate)) AS [parcel arrives in days]
FROM orders


-- Task: find the number of days between each order and the previous order
SELECT 
orderID,
orderDate AS currentDate,
LAG(orderDate) OVER(ORDER BY orderDate) AS previous_order_date, -- LAG returns previous record
DATEDIFF(DAY, LAG(orderDate) OVER(ORDER BY orderDate), orderDate) AS days_after_last_order
FROM orders



-- validation function

SELECT 
ISDATE('123') datechaeck1,
ISDATE('2225') datechaeck2, -- SQL thinks it's an year
ISDATE(2026) datechaeck3,
ISDATE('yyyy') datechaeck4,
ISDATE('2025-02-19') datechaeck5,
ISDATE('20') datechaeck6,
ISDATE('2024,09,12') datechaeck7,
ISDATE('yyyy-MM-dd') datechaeck8


SELECT
orderDate,
ISDATE(orderDate) AS isValidDate,
CASE WHEN ISDATE(orderDate) = 1 THEN CAST(orderDate AS DATE)
END New_order_date
FROM
(
	SELECT '2023-12' AS orderDate UNION
	SELECT '2025-12-12' UNION
	SELECT '2025-01-12' UNION
	SELECT '2025-02-13' UNION
	SELECT '2020'
)t
