-- 1907. Count Salary Categories
WITH CTEA AS (
    SELECT
        account_id,
        income,
        CASE
            WHEN income < 20000 THEN 'Low Salary'
            WHEN income > 50000 THEN 'High Salary'
            ELSE 'Average Salary'
        END AS category
    FROM Accounts
),
AllCategories AS (
    SELECT 'Low Salary' AS category
    UNION ALL
    SELECT 'Average Salary'
    UNION ALL
    SELECT 'High Salary'
),
Counts AS (
    SELECT category, COUNT(*) AS accounts_count
    FROM CTEA
    GROUP BY category
)
SELECT
    a.category,
    COALESCE(c.accounts_count, 0) AS accounts_count
FROM AllCategories a
LEFT JOIN Counts c ON a.category = c.category;


-- 550. Game Play Analysis IV
WITH FirstLogins AS (
    SELECT player_id, MIN(event_date) AS first_login_date
    FROM Activity
    GROUP BY player_id
),
NextDayLogins AS (
    SELECT DISTINCT a.player_id
    FROM Activity a
    JOIN FirstLogins f
      ON a.player_id = f.player_id
     AND a.event_date = DATEADD(DAY, 1, f.first_login_date)
)
SELECT
    ROUND(
        CAST(COUNT(*) AS FLOAT) / 
        (SELECT COUNT(DISTINCT player_id) FROM Activity),
    2) AS fraction
FROM NextDayLogins;


-- 1341. Movie Rating
WITH UserRatings AS (
    SELECT user_id, COUNT(*) AS rating_count
    FROM MovieRating
    GROUP BY user_id
),
TopUsers AS (
    SELECT user_id
    FROM UserRatings
    WHERE rating_count = (SELECT MAX(rating_count) FROM UserRatings)
),
FebRatings AS (
    SELECT movie_id, rating
    FROM MovieRating
    WHERE created_at >= '2020-02-01' AND created_at < '2020-03-01'
),
MovieAvg AS (
    SELECT movie_id, AVG(rating * 1.0) AS avg_rating
    FROM FebRatings
    GROUP BY movie_id
),
TopMovies AS (
    SELECT movie_id
    FROM MovieAvg
    WHERE avg_rating = (SELECT MAX(avg_rating) FROM MovieAvg)
)

-- User with most ratings (tie → lex smallest name)
SELECT MIN(name) AS results
FROM Users
WHERE user_id IN (SELECT user_id FROM TopUsers)

UNION ALL

-- Movie with highest avg Feb rating (tie → lex smallest title)
SELECT MIN(title)
FROM Movies
WHERE movie_id IN (SELECT movie_id FROM TopMovies);



-- 1934. Confirmation Rate
WITH CTEC AS(
    SELECT
        user_id,
        time_stamp,
        action,
        CASE
            WHEN action='timeout' THEN 0
            ELSE 1
        END AS dig
    FROM Confirmations
),
CTEAVG AS(
    SELECT
        user_id,
        ROUND(AVG(dig*1.0), 2) AS avg
    FROM CTEC
    GROUP BY user_id
)
SELECT
    s.user_id,
    COALESCE(avg, 0) AS confirmation_rate
FROM Signups s
LEFT JOIN CTEAVG c
ON s.user_id=c.user_id


-- 3220. Odd and Even Transactions
SELECT
    transaction_date,
    SUM(CASE WHEN amount%2=1 THEN amount ELSE 0 END) AS odd_sum,
    SUM(CASE WHEN amount%2=0 THEN amount ELSE 0 END) AS even_sum
FROM transactions
GROUP BY transaction_date


-- 