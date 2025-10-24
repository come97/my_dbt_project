-- models/mart/mrt_monthly_order_report.sql

WITH base_orders AS (
  SELECT
    DATE_TRUNC(DATE(order_date), MONTH) AS order_month,
    user_name,
    order_id
  FROM {{ source('sales_database', 'order') }}
),

users_norm AS (
  SELECT
    user_name,
    UPPER(TRIM(customer_state)) AS customer_state_norm
  FROM {{ source('sales_database', 'user') }}
),

monthly_users_recap AS (
  SELECT
    order_month,
    COUNT(DISTINCT user_name) AS total_monthly_users
  FROM base_orders
  GROUP BY order_month
),

total_monthly_user_from_jawa_timur AS (
  SELECT
    o.order_month,
    COUNT(DISTINCT o.user_name) AS total_monthly_users_from_jawa_timur
  FROM base_orders o
  LEFT JOIN users_norm u USING (user_name)
  WHERE u.customer_state_norm = 'JAWA TIMUR'
  GROUP BY o.order_month
),

monthly_orders_recap AS (
  SELECT
    order_month,
    COUNT(DISTINCT order_id) AS total_monthly_orders
  FROM base_orders
  GROUP BY order_month
)

SELECT
  u.order_month,
  COALESCE(u.total_monthly_users, 0)                           AS nb_users_monthly,
  COALESCE(jt.total_monthly_users_from_jawa_timur, 0)          AS total_monthly_user,
  COALESCE(o.total_monthly_orders, 0)                          AS monthly_order_count
FROM monthly_users_recap u
LEFT JOIN total_monthly_user_from_jawa_timur jt ON jt.order_month = u.order_month
LEFT JOIN monthly_orders_recap o               ON o.order_month  = u.order_month
ORDER BY u.order_month;
