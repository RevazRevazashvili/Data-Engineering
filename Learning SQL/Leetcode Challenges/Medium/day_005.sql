-- 3497. Analyze Subscription Conversion 
WITH CTEU AS (
    SELECT
        user_id,
        ROUND(AVG(activity_duration*1.0), 2) AS paid_avg_duration
    FROM UserActivity
    WHERE activity_type='paid'
    GROUP BY user_id
),
CTEF AS(
    SELECT
        user_id,
        ROUND(AVG(activity_duration*1.0), 2) AS trial_avg_duration
    FROM UserActivity
    WHERE activity_type='free_trial' AND user_id IN (SELECT user_id FROM CTEU)
    GROUP BY user_id
)
SELECT
    ce.user_id,
    cf.trial_avg_duration,
    ce.paid_avg_duration
FROM CTEU AS ce
JOIN CTEF AS cf
ON ce.user_id=cf.user_id
