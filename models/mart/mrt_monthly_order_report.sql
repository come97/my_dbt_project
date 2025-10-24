WITH base_orders AS (
  SELECT
    DATE_TRUNC(DATE(order_created_at), MONTH) AS order_month,
    user_id,
    order_id
  FROM {{ ref('stg_sales_database__order') }}
),

users_norm AS (
  SELECT
    user_id,
    user_state
  FROM {{ ref('stg_sales_database__user') }}
),

monthly_users_recap AS (
  SELECT
    order_month,
    COUNT(DISTINCT user_id) AS total_monthly_users
  FROM base_orders
  GROUP BY order_month
),

total_monthly_user_from_jawa_timur AS (
  SELECT
    o.order_month,
    COUNT(DISTINCT o.user_id) AS total_monthly_users_from_jawa_timur
  FROM base_orders o
  LEFT JOIN users_norm u USING (user_id)
  WHERE u.user_state = 'JAWA TIMUR'
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
ORDER BY u.order_month
