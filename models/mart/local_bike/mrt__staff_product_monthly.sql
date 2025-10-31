select
  month,
  staff_name,
  product_name,
  sum(quantity) as total_quantity_sold,
  sum(net_revenue) as total_revenue
from {{ ref('int__items_enriched') }}
group by month, staff_name, product_name