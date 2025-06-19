-- 1204. Last Person to Fit in the Bus.
WITH CTEB AS (
    SELECT
    *,
    SUM(weight) OVER(ORDER BY turn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) rolingSum
    FROM Queue
)
SELECT
	TOP 1
	person_name
FROM CTEB
WHERE rolingSum<=1000
ORDER BY rolingSum DESC


-- 1174. Immediate Food Delivery II
WITH newDelivery AS (
    SELECT
        customer_id,
        DATEDIFF(day, order_date, customer_pref_delivery_date) AS ddif,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS rank
    FROM Delivery
)
SELECT
    ROUND(
        COUNT(CASE WHEN ddif = 0 AND rank = 1 THEN customer_id END) * 100.0 / 
        COUNT(DISTINCT customer_id),
        2
    ) AS immediate_percentage
FROM newDelivery


-- 1164. Product Price at a Given Date
SELECT 
    p.product_id,
    COALESCE(latest.new_price, 10) AS price
FROM 
    (SELECT DISTINCT product_id FROM Products) p
LEFT JOIN (
    SELECT 
        product_id,
        new_price
    FROM (
        SELECT 
            product_id,
            new_price,
            ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY change_date DESC) AS rn
        FROM Products
        WHERE change_date <= '2019-08-16'
    ) t
    WHERE rn = 1
) latest ON p.product_id = latest.product_id;


-- 1158. Market Analysis I
WITH analisys AS (
	SELECT
	DISTINCT
	o.buyer_id AS buyer_id,
	u.join_date,
	COUNT(*) OVER(PARTITION BY o.buyer_id) AS orders_in_2019
	FROM Users u
	LEFT JOIN Orders o
	ON u.user_id=o.buyer_id
	WHERE o.order_date BETWEEN '2019-01-01' AND '2019-12-31'
)
SELECT * FROM analisys
UNION
SELECT
	user_id,
	join_date,
	0
FROM Users
WHERE user_id NOT IN(SELECT buyer_id FROM analisys)


-- 1070. Product Sales Analysis III
WITH firstYear AS(
	SELECT
	product_id,
	year,
	quantity,
	price,
	RANK() OVER(PARTITION BY product_id ORDER BY year) rank
	FROM Sales
)
SELECT
	product_id,
	year AS first_year,
	quantity,
	price
FROM firstYear
WHERE rank=1


-- 1045. Customers Who Bought All Products
SELECT
	customer_id
FROM
	(SELECT
	customer_id,
	COUNT(DISTINCT product_key) AS amount
FROM Customer
GROUP BY customer_id)t
WHERE amount=(SELECT COUNT(*) FROM product)


-- 608. Tree Node
SELECT
id,
CASE
    WHEN p_id IS NULL THEN 'Root'
    WHEN id NOT IN (SELECT COALESCE(p_id, -1) FROM Tree) THEN 'Leaf'
    ELSE 'Inner'
END AS type
FROM Tree


-- 602. Friend Requests II: Who Has the Most Friends
SELECT
TOP 1
    ID,
    COUNT(*) AS num
FROM (
    SELECT requester_id AS ID FROM RequestAccepted
    UNION ALL
    SELECT accepter_id FROM RequestAccepted
) AS all_ids
GROUP BY ID
ORDER BY num DESC