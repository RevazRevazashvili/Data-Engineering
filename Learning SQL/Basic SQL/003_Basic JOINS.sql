/* SQL JOINS - basics
INNER, LEFT, RIGHT, FULL
joins are the way to combine data from multiple tables into one query
*/

-- INNER JOIN
-- inner join returns only the rows from tables that have a column in common
-- for example customer id from customers and customerID in orders
-- Note: it's not important which table will be the first in order of tables
-- TASK: select only the custommers who made an order
SELECT * FROM customers c
INNER JOIN orders o on c.id=o.customerID;


-- LEFT JOIN
-- left join returns all the rows from left table combined the rows from second table that matches
-- for example customer id from customers and customerID in orders
-- Note: it's important which table will be the first in order of tables
-- TASK: select every custommers no matter they made an order or not
SELECT * FROM customers c
LEFT JOIN orders o on c.id=o.customerID;


-- RIGHT JOIN
/* right join is very same of lect join but here right table is main. everything from right 
table and everything from left table that matches */
-- for example customer id from customers and customerID in orders
-- Note: it's important which table will be the first in order of tables
-- TASK: select every orders no matter does it have customer or not
SELECT * FROM customers c
RIGHT JOIN orders o on c.id=o.customerID;


-- FULL JOIN
/* full join combines all the data */
-- Note: it's not important which table will be the first in order of tables
-- TASK: select every customers and orders
SELECT * FROM customers c
FULL JOIN orders o on c.id=o.customerID;