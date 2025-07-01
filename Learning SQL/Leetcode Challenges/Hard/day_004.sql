-- 185. Department Top Three Salaries
WITH CTEE AS (
    SELECT
        id,
        name,
        salary,
        departmentId,
        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS rn
    FROM Employee
)
SELECT
    d.name AS Department,
    c.name AS Employee,
    c.salary
FROM CTEE c
INNER JOIN Department d
ON c.departmentId=d.id
WHERE c.rn<4


-- 262. Trips and Users
SELECT
    request_at AS Day,
    ROUND(
        SUM(CASE WHEN status LIKE 'cancelled%' AND u1.banned = 'No' THEN 1 ELSE 0 END) * 1.0 /
        NULLIF(SUM(CASE WHEN u1.banned = 'No' THEN 1 ELSE 0 END), 0),
        2
    ) AS [Cancellation Rate]
FROM Trips t
JOIN Users u1 ON t.client_id = u1.users_id
JOIN Users u2 ON t.driver_id = u2.users_id
WHERE u1.banned = 'No' AND u2.banned = 'No'
  AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at
ORDER BY request_at;


-- 