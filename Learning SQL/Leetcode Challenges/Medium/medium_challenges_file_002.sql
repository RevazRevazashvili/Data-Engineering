-- 3475. DNA Pattern Recognition 
SELECT
*,
CASE
    WHEN SUBSTRING(dna_sequence, 0, 4)='ATG' THEN 1 ELSE 0
END AS has_start,
CASE
    WHEN SUBSTRING(dna_sequence, LEN(dna_sequence)-2, LEN(dna_sequence)) IN 
    ('TAA', 'TAG', 'TGA') THEN 1 ELSE 0
END AS has_stop,
CASE
    WHEN dna_sequence LIKE '%ATAT%' THEN 1 ELSE 0
END AS has_atat,
CASE
    WHEN dna_sequence LIKE '%GGG%' THEN 1 ELSE 0
END AS has_ggg
FROM Samples


-- 1321. Restaurant Growth
WITH DailyTotals AS (
    SELECT
        visited_on,
        SUM(amount) AS total_amount
    FROM Customer
    GROUP BY visited_on
)
SELECT
    visited_on,
    SUM(total_amount) OVER(
        ORDER BY visited_on
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS amount,
    ROUND(AVG(total_amount*1.0) OVER(
        ORDER BY visited_on
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS average_amount
FROM DailyTotals
ORDER BY visited_on
OFFSET 6 ROWS;
