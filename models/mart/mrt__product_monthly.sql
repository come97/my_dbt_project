with base as (
  select
        month,
        product_id,
        any_value(product_name)  as product_name,
        any_value(brand_name)    as brand_name,
        any_value(category_name) as category_name,
        sum(qty)                 as qty,
        sum(list_value)          as list_value,
        sum(revenue)             as revenue
  from {{ ref('int__sales_monthly_base') }}
  group by 1,2
),

enriched as (
  select
      month,
      product_id,
      product_name,
      brand_name,
      category_name,
      qty            as total_quantity_sold,
      revenue        as total_revenue,
      safe_divide(revenue, qty)                   as asp,
      1 - safe_divide(revenue, nullif(list_value,0)) as discount_rate
  from base
),

shares as (
  select
    e.*,
    safe_divide(
      e.total_revenue,
      sum(e.total_revenue) over (partition by e.month)
    ) as share_of_revenue
  from enriched e
)

select
  s.*,
  dense_rank() over (partition by s.month order by s.total_revenue desc)             as rank_revenue_month,
  dense_rank() over (partition by s.month, s.category_name order by s.total_revenue desc) as rank_in_category_month,
  safe_divide(
    s.total_revenue - lag(s.total_revenue) over (partition by s.product_id order by s.month),
    lag(s.total_revenue) over (partition by s.product_id order by s.month)
  ) as mom_revenue_growth,
  safe_divide(
    s.total_quantity_sold - lag(s.total_quantity_sold) over (partition by s.product_id order by s.month),
    lag(s.total_quantity_sold) over (partition by s.product_id order by s.month)
  ) as mom_qty_growth
from shares s