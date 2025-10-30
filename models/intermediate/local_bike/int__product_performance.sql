select 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    sum(oi.quantity) as total_quantity,
    sum(oi.list_price * oi.quantity * (1 - oi.discount)) as total_revenue,
    avg(oi.list_price) as avg_price
from {{ ref('stg__order_items') }} oi
join {{ ref('stg__products') }} p using (product_id)
join {{ ref('stg__brands') }} b using (brand_id)
join {{ ref('stg__categories') }} c using (category_id)
group by 1,2,3,4
