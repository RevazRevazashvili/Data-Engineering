-- 1527. Patients With a Condition
SELECT *
FROM Patients
WHERE EXISTS (
    SELECT 1
    FROM STRING_SPLIT(conditions, ' ') AS s
    WHERE s.value LIKE 'DIAB1%'
)


-- 1731. The Number of Employees Which Report to Each Employee
SELECT
    e2.employee_id,
    e1.name,
    e2.reports_count,
    FLOOR(e2.average_age + 0.5) AS average_age
FROM Employees e1
JOIN (
    SELECT
        reports_to AS employee_id,
        COUNT(*) AS reports_count,
        AVG(CAST(age AS FLOAT)) AS average_age
    FROM Employees
    WHERE reports_to IS NOT NULL
    GROUP BY reports_to
) e2 ON e1.employee_id = e2.employee_id


-- 1789. Primary Department for Each Employee
WITH CTEE AS(
    SELECT
    employee_id,
    department_id
    FROM Employee
    WHERE primary_flag='Y'
)
SELECT
*
FROM CTEE
UNION
SELECT
    employee_id,
    department_id
FROM Employee
WHERE employee_id NOT IN (SELECT employee_id FROM CTEE)


-- 1795. Rearrange Products Table
SELECT
*
FROM(
	SELECT
		product_id,
		CASE WHEN store1 IS NOT NULL THEN 'store1' END AS store,
		store1 AS price
	FROM Products
	UNION
	SELECT
		product_id,
		CASE WHEN store2 IS NOT NULL THEN 'store2' END AS store,
		store2
	FROM Products
	UNION
	SELECT
		product_id,
		CASE WHEN store3 IS NOT NULL THEN 'store3' END AS store,
		store3
	FROM Products
	)t
WHERE store IS NOT NULL


-- 1873. Calculate Special Bonus
SELECT
	employee_id,
CASE
    WHEN employee_id%2=1 AND name NOT LIKE 'M%' THEN salary
    ELSE 0
END AS bonus
FROM Employees
ORDER BY employee_id


-- 1890. The Latest Login in 2020
SELECT
    user_id,
    MAX(time_stamp) AS last_stamp
FROM Logins
WHERE FORMAT(time_stamp, 'yyyy-MM-dd') BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY user_id