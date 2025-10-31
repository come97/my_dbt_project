select 
category_id, 
category_name
FROM {{ source('local_bike', 'categories') }}