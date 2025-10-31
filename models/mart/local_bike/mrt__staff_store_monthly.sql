with base as (
  select
    month,
    staff_name,
    store_name,
    sum(quantity) as total_quantity_sold,
    sum(gross_value) as list_value,
    sum(net_revenue) as total_revenue
  from {{ ref('int__items_enriched') }}
  group by month, staff_name, store_name
)

select
  month,
  staff_name,
  store_name,
  total_quantity_sold,
  total_revenue,
  safe_divide(total_revenue, total_quantity_sold) as average_selling_price,
  1 - safe_divide(total_revenue, nullif(list_value, 0)) as discount_rate,
  safe_divide(
    total_revenue,
    sum(total_revenue) over (partition by month, store_name)
  ) as share_of_store_revenue
from base
