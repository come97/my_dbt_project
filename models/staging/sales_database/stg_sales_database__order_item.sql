select 
 CONCAT(order_id, '_', product_id) AS order_item_id,
 order_id as order_id,
 product_id as product_id,
 1 as column_1,
 seller_id as seller_id,
 DATETIME(pickup_limit_date, "Europe/Paris") as picked_up_limited_at,
 price as unit_price,
 shipping_cost as shipping_cost,
 quantity as item_quantity,
 (price * quantity) + shipping_cost as total_order_item_amount
from {{ source('sales_database', 'order_item') }}
