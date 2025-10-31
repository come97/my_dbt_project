with base as (
  select
    oi.order_id,
    oi.item_id,
    oi.product_id,
    oi.quantity,
    oi.list_price,
    oi.discount,
    o.order_date,
    o.store_id,
    s.store_name,
    p.product_name,
    p.brand_id,
    b.brand_name,
    p.category_id,
    c.category_name,
    st.staff_name
  from {{ ref('stg__order_items') }} oi
  join {{ ref('stg__orders') }} o using (order_id)
  join {{ ref('stg__stores') }} s using (store_id)
  join {{ ref('stg__products') }} p using (product_id)
  join {{ ref('stg__brands') }} b using (brand_id)
  join {{ ref('stg__categories') }} c using (category_id)
  join {{ ref('stg__staffs') }} st using (staff_id)
)

select
  *,
  quantity * list_price as gross_value,          
  quantity * list_price * (1 - discount) as net_revenue,       
  date_trunc(order_date, month) as month
from base