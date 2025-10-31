with base_table as (
  select 
    month,
    staff_name,
    sum(quantity)      as total_quantity_sold,
    sum(gross_value)   as list_value,
    sum(net_revenue)   as total_revenue
  from {{ ref('int__items_enriched') }}
  group by 1,2
),

enriched as (
  select
    month,
    staff_name,
    total_quantity_sold,
    total_revenue,
    safe_divide(total_revenue, total_quantity_sold) as average_selling_price,
    1 - safe_divide(total_revenue, nullif(list_value, 0)) as discount_rate,
    safe_divide(
      total_revenue,
      sum(total_revenue) over (partition by month)
    ) as share_of_total_revenue
  from base_table
)

select
  e.*,
  dense_rank() over (partition by e.month order by e.total_revenue desc) as rank_revenue_month,
  safe_divide(
    e.total_revenue - lag(e.total_revenue) over (partition by e.staff_name order by e.month),
    lag(e.total_revenue) over (partition by e.staff_name order by e.month)
  ) as mom_revenue_growth,
  safe_divide(
    e.total_quantity_sold - lag(e.total_quantity_sold) over (partition by e.staff_name order by e.month),
    lag(e.total_quantity_sold) over (partition by e.staff_name order by e.month)
  ) as mom_qty_growth
from enriched e