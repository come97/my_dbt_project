
select CONCAT(order_id, '_', product_id) AS order_item_id_y,
 order_id as order_id_y,
 product_id as product_id_y,
 1 AS column_1_y,
 seller_id as seller_id_y,
 DATETIME(pickup_limit_date, "Europe/Paris") as picked_up_limited_at_x,
 price as unit_price_y,
 shipping_cost as shipping_cost_y,
 quantity as item_quantity_y,
 (price * quantity) + shipping_cost as total_order_item_amount_y
from {{ source('sales_database', 'order_item') }}
