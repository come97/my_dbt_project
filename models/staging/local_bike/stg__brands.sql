select 
brand_id, 
brand_name
FROM {{ source('local_bike', 'brands') }}