-- 601. Human Traffic of Stadium
WITH CTES AS(
    SELECT
    *,
    ABS(ROW_NUMBER() OVER(ORDER BY visit_date)-id) AS rn
    FROM Stadium
    WHERE people >= 100
),
CTEG AS (
    SELECT
    rn,
    COUNT(*) AS count
    FROM CTES
    GROUP BY rn
    HAVING COUNT(*) >= 3
)
SELECT
	id,
	visit_date,
	people
FROM CTES
WHERE rn IN (SELECT rn FROM CTEG)


-- 3374. First Letter Capitalization II
WITH CTET AS (
    SELECT content_id, content_text,  value AS word
    FROM user_content
    CROSS APPLY STRING_SPLIT(content_text, ' ')
)
SELECT
    content_id,
    content_text AS original_text,
    STRING_AGG(
        CASE
            -- If the word does not contain a hyphen
            WHEN CHARINDEX('-', word) = 0 THEN
                UPPER(LEFT(word, 1)) + LOWER(SUBSTRING(word, 2, LEN(word)))
            
            -- If the word contains a hyphen (e.g., user-friendly)
            ELSE
                -- Split the word into two parts at the hyphen and capitalize both
                UPPER(LEFT(word, 1)) +
                LOWER(SUBSTRING(word, 2, CHARINDEX('-', word) - 1)) +
                UPPER(SUBSTRING(word, CHARINDEX('-', word) + 1, 1)) +
                LOWER(SUBSTRING(word, CHARINDEX('-', word) + 2, LEN(word)))
        END,
        ' '
    ) AS converted_text
FROM CTET
GROUP BY content_id, content_text
ORDER BY content_id
