-- 626. Exchange Seats
WITH CTES AS(
    SELECT
    *,
    LEAD(student) OVER(ORDER BY id) AS ld,
    LAG(student) OVER(ORDER BY id) AS lg
    FROM Seat
)
SELECT
id,
CASE 
    WHEN id%2=1 THEN COALESCE(ld, student)
    WHEN id%2=0 THEN lg
    ELSE student
END AS student
FROM CTES