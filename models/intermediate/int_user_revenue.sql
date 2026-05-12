-- Convert British Pounds (GBP) to Canadian Dollars (CAD) for consistent reporting (approx rate 1.7)
SELECT
    user_id,
    CASE
        WHEN preferred_currency = 'GBP' THEN plan_price * 1.7
        ELSE plan_price
    END AS revenue_cad
FROM {{ref('stg_users')}}