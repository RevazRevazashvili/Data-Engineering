-- Optimazing Technique - Index
USE MySalesDB


-- Unique and Filtered Indexes

/*
	An Unique index ensures no duplicate values exists in specific column.
	Benefits:
			1. Enforce Uniquenese
			2. Slightly improves query performance
	Performance:
		writing to an unique index is slower than non-unique.
		reading from an unique index is faster than from non-unique.

*/

-- quick check table
SELECT * FROM products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON products (productName)

-- now lets try to insert another product row with the same product name
INSERT INTO products(productName, price) VALUES ('bat', 13.50)


/*
	A Filtered index is an index that includes only rows meeting the specific condition.
	Benefits:
			1. Targeted optimization.
			2. Reduce storage: less data in the index
	Rules:
		You cannot create a filtered index on a clustered index.
		You cannot create a filtered index on a columnstore index.

*/

/*
	lets say we always query the male customers. To optimize the query we can create
	a filtered index.
*/

SELECT * FROM customers
WHERE gender = 'M'

CREATE NONCLUSTERED INDEX idx_Customers_Male
ON customers (gender)
WHERE gender = 'M'