-- 3482. Analyze Organization Hierarchy
WITH CTEH AS (
    SELECT
        employee_id,
        employee_name,
        manager_id,
        salary,
        department,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        e.department,
        ct.level + 1
    FROM Employees e
    JOIN CTEH ct
        ON e.manager_id = ct.employee_id
),

-- 2. Recursive tree for building employee -> subordinates paths
EmployeeHierarchy AS (
    SELECT
        employee_id AS manager_id,
        employee_id AS employee_id
    FROM Employees

    UNION ALL

    SELECT
        eh.manager_id,
        e.employee_id
    FROM EmployeeHierarchy eh
    JOIN Employees e
        ON e.manager_id = eh.employee_id
),

-- 3. Compute team size (excluding self)
TeamSize AS (
    SELECT
        manager_id,
        COUNT(*) - 1 AS team_size
    FROM EmployeeHierarchy
    GROUP BY manager_id
),

-- 4. Compute salary budget (including self)
SalaryBudget AS (
    SELECT
        eh.manager_id,
        SUM(e.salary) AS salary_budget
    FROM EmployeeHierarchy eh
    JOIN Employees e
        ON eh.employee_id = e.employee_id
    GROUP BY eh.manager_id
)

-- 5. Final output
SELECT
    c.employee_id,
    c.employee_name,
    c.level,
    ISNULL(ts.team_size, 0) AS team_size,
    ISNULL(sb.salary_budget, c.salary) AS budget
FROM CTEH c
LEFT JOIN TeamSize ts ON c.employee_id = ts.manager_id
LEFT JOIN SalaryBudget sb ON c.employee_id = sb.manager_id
ORDER BY c.level, sb.salary_budget DESC, c.employee_name