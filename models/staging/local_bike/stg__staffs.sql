select
staff_id,
concat(upper(substr(first_name, 1, 1)), '. ', last_name) as staff_name,
first_name,
last_name,
email,
phone,
active,
store_id, 
manager_id
from {{ source('local_bike', 'staffs') }}