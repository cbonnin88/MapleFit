SELECT
    u.user_id,
    u.country,
    u.membership_tier,
    r.revenue_cad,
    COUNT(e.user_id) AS total_events,
    MIN(e.event_date) AS first_active_date,
    MAX(e.event_date) AS last_active_date
FROM {{ref('stg_users')}} AS u 
JOIN {{ref('int_user_revenue')}} AS r
    ON u.user_id = r.user_id
LEFT JOIN {{ref('stg_events')}} AS e
    ON u.user_id = e.user_id
GROUP BY
    u.user_id,
    u.country,
    u.membership_tier,
    r.revenue_cad
