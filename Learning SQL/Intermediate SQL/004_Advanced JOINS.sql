/* SQL JOINS - Advanced
LEFT Anti-join, RIGHT Anti-join, FULL Anti-join, CROSS join
joins are the way to combine data from multiple tables into one query
*/


-- LEFT ANTI JOIN
-- left anti join returns all the rows from left table except those rows that have both tables and the second table
-- for example customer id from customers and customerID in orders
-- Note: it's important which table will be the first in order of tables
-- TASK: select every custommers but not those who has made an order
SELECT * FROM customers c
LEFT JOIN orders o on c.id=o.customerID
WHERE o.customerID IS NULL;


-- RIGHT ANTI JOIN
/* right anti join is very similar of left anti join but here right table is main. */
-- for example customer id from customers and customerID in orders
-- Note: it's important which table will be the first in order of tables
-- TASK: select every orders but not those that have not customer
SELECT * FROM customers c
RIGHT JOIN orders o on c.id=o.customerID
WHERE c.id IS NULL;


-- FULL ANTI JOIN
/* full join combines all the data except those that matches in both tables. */
-- Note: it's not important which table will be the first in order of tables
-- TASK: select every customers and orders except those that matches in both tables.
SELECT * FROM customers c
FULL JOIN orders o on c.id=o.customerID
WHERE c.id IS NULL OR o.customerID IS NULL;


-- CROSS JOIN
/* cross join returns data like all-by-all, if one table has 5 rows and another - 4, 
the cross join will return 20 rows. */
-- Note: it's not important which table will be the first in order of tables
-- TASK: select every customers and orders.
SELECT * FROM customers c
CROSS JOIN orders o;


-----------------------------------------------------

-- Multiple joins

/* Join that combines data of more than 2 tables is multi-join*/
-- Multi INNER JOIN
SELECT * FROM orders o
INNER JOIN customers c ON o.customerID=c.id
INNER JOIN products p ON o.productsID=p.productID


-- Multi LEFT JOIN
SELECT * FROM orders o
LEFT JOIN customers c ON o.customerID=c.id
LEFT JOIN products p ON o.productsID=p.productID


-- Multi FULL JOIN
SELECT * FROM orders o
FULL JOIN customers c ON o.customerID=c.id
FULL JOIN products p ON o.productsID=p.productID