-- NULL Functions
USE MySalesDB

-- ISNULL is the function that will replace NULL values by the passed value
SELECT
id,
score,
AVG(score) OVER() avgscore,
AVG(ISNULL(score, 0)) OVER() avgscore2
FROM sales


/* COALESCE is the function that will replace NULL values by the passed value,
however, we can pass any number of values, it will go through all the passed 
values and selects first not null value and will fill null value with it.
*/
SELECT
id,
score,
AVG(score) OVER() avgscore,
AVG(COALESCE(score, 0)) OVER() avgscore2
FROM sales

-- Task: add bonus 10 score to all customers
SELECT
id,
score,
score+10 AS bonus,
COALESCE(score, 0) + 10 AS bonus2
FROM sales


-- Task: sort the customers from the lowest to the highest scores,
-- with nulls appearing last
SELECT
id,
score
FROM sales
ORDER BY CASE WHEN score IS NULL THEN 1 ELSE 0 END, score


-- NULLIF checks whether two values are equal or not, if yes it fills cell with null
SELECT
id,
score,
id/NULLIF(score, 0) -- it prevents from division by zero error
FROM sales
