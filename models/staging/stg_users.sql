SELECT
    CAST(user_id AS STRING) AS user_id,
    CAST(signup_date AS DATE) AS signup_date,
    country,
    city,
    membership_tier,
    membership_plan_cad AS plan_price,
    preferred_currency
FROM {{source('maple_fit','users')}}