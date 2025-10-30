select 
    o.order_id, 
    o.store_id,
    s.store_name,
    o.order_date,
    sum(quantity * list_price * (1 - discount)) AS order_total_paid
from {{ ref('stg__order_items') }} oi
join {{ ref('stg__orders') }} o using (order_id)
join {{ ref('stg__stores') }} s using (store_id)
group by o.order_id, o.store_id, o.order_date, s.store_name