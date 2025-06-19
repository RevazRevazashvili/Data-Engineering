-- 1661. Average Time of Process per Machine
SELECT
    machine_id,
    ROUND(SUM(newstamp)/COUNT(DISTINCT process_id), 3) AS processing_time
FROM
(SELECT
*,
CASE
    WHEN activity_type='start' THEN timestamp*(-1)
    ELSE timestamp
END AS newstamp
FROM Activity)t
GROUP BY machine_id


-- 1693. Daily Leads and Partners
SELECT
    date_id,
    make_name,
    COUNT(DISTINCT lead_id) AS unique_leads,
    COUNT(DISTINCT partner_id) AS unique_partners
FROM DailySales
GROUP BY date_id, make_name


-- 1731. The Number of Employees Which Report to Each Employee
SELECT
	e2.employee_id,
	e1.name,
	e2.reports_count,
	e2.average_age
FROM Employees e1
JOIN
(SELECT
	reports_to AS employee_id,
	COUNT(reports_to) AS reports_count,
	CEILING(AVG(age*1.0)) AS average_age
	FROM Employees
	WHERE reports_to IS NOT NULL
	GROUP BY reports_to)e2 ON e1.employee_id=e2.employee_id


-- 1741. Find Total Time Spent by Each Employee
SELECT
    event_day AS day,
    emp_id,
    SUM(out_time-in_time) AS total_time
FROM Employees
GROUP BY event_day, emp_id


-- 1757. Recyclable and Low Fat Products
SELECT
    product_id
FROM Products
WHERE low_fats=recyclable and low_fats='Y'


