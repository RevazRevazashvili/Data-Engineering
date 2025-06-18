-- Conditions - CASE->WHEN->THEN
/*
	Case Statement evaluates a list of conditions and returns a value
	when the first condition is met
*/

USE MySalesDB

-- a quick view of the table
SELECT * FROM sales


/*
	create report showing total sales for each of the following
	categories: High(sales over 500), Medium(sales between 200-500),
	Low(sales 200 or less).
	Sort the categories from highest sales to lowest.	
*/
SELECT 
category,
SUM(score) AS totalSales
FROM(
	SELECT
	id,
	score,
	CASE
		WHEN score > 500 THEN 'High'
		WHEN score > 200 THEN 'Medium'
		ELSE 'Low'
	END AS category
	FROM sales
)t
GROUP BY category
ORDER BY totalSales DESC


-- we can use CASE WHEN statement for information mapping.
-- Task: map gender abbreviation to its full text.
SELECT
	customerName,
	customerName,
	age,
	gender,
	CASE
		WHEN gender='F' THEN 'Female'
		WHEN gender='M' THEN 'Male'
		ELSE 'n/a'
	END AS genderFullText
FROM customers


-- we could use quick form of CASE statement if only all WHEN statement have the same condition(equal, =)
-- for example in all statement we only check genders.
-- Task: map gender abbreviation to its full text.
SELECT
	customerName,
	customerName,
	age,
	gender,
	CASE gender
		WHEN 'F' THEN 'Female'
		WHEN 'M' THEN 'Male'
		ELSE 'n/a'
	END AS genderFullText
FROM customers


-- handling null values by CASE WHEN statement and then
-- calculating average score
SELECT
id,
score,
CASE
	WHEN score IS NULL THEN 0
	ELSE score
END scoreclean,
AVG(CASE
	WHEN score IS NULL THEN 0
	ELSE score
END) OVER() avgcustomerclean,
AVG(score) OVER() avgcustomer
FROM sales
