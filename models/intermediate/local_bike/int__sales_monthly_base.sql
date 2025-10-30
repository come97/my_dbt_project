select
    month,
    product_id,
    product_name,
    brand_id,
    brand_name,
    category_id,
    category_name,
    store_id,
    store_name,
    sum(quantity) as qty,
    sum(gross_value) as list_value,
    sum(net_revenue) as revenue
from {{ ref('int__items_enriched') }}
group by
  month, product_id, product_name, brand_id, brand_name, category_id, category_name, store_id, store_name