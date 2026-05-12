SELECT
    CAST(user_id AS STRING) AS user_id,
    event_type,
    CAST(timestamp AS datetime) AS event_at,
    DATE(timestamp) AS event_date
FROM {{source('maple_fit','events')}}