-- SET Operations

USE MySalesDB

-- a quick check for table contents
select * from customers
select * from employee
select * from products
select * from orders


/* UNION
UNION will combine all distinct rows from tables. */
-- Task: query all customers and employees
SELECT customerName FROM customers
UNION
SELECT employeeName FROM employee


/* UNION ALL
UNION ALL will combine all rows from tables, including duplicates. */
-- Task: query all customers and employees including duplicates
SELECT customerName FROM customers
UNION ALL
SELECT employeeName FROM employee


/* EXCEPT
EXCEPT returns all distinct rows from the first query that are not found in the second query. 
the tables order matter here. */
-- Task: query all customers who are not employees at the same time
SELECT customerName FROM customers
EXCEPT
SELECT employeeName FROM employee


/* INTERSECT
INTERSECT returns only the rows that are common in both queries. */
-- Task: query all who are customers and employees at the same time
SELECT customerName FROM customers
INTERSECT
SELECT employeeName FROM employee