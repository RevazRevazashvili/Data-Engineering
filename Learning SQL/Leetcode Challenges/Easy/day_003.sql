-- 1965. Employees With Missing Information
WITH CTEE AS (
    SELECT
        e.employee_id AS e1,
        e.name,
        s.employee_id AS e2,
        s.salary
    FROM Employees e
    FULL JOIN Salaries s
    ON e.employee_id=s.employee_id
)
SELECT
    e1 AS employee_id
FROM CTEE
WHERE salary IS NULL
UNION ALL
SELECT
    e2
FROM CTEE
WHERE name IS NULL
ORDER BY employee_id


-- 1978. Employees Whose Manager Left the Company
SELECT
    employee_id
FROM Employees
WHERE salary<30000
AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id


-- 2356. Number of Unique Subjects Taught by Each Teacher
SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id