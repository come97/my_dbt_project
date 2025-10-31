with base_table as (
    select
    order_id, 
    store_name,
    order_date,
    order_total_paid
    from {{ ref('int__order_revenue') }}
)

select 
date_trunc(order_date, month) as month,
store_name,
round(sum(order_total_paid), 2) as total_sales, 
count(distinct order_id) as number_of_orders, 
round(safe_divide(SUM(order_total_paid), COUNT(*)), 2) as average_basket  
from base_table
group by month, store_name