select
    cast(id as string) as listing_id,
    cast(host_id as integer) as host_id,
    cast(neighbourhood_cleansed as string) as neighbourhood_cleansed,
    cast(room_type as string) as room_type,
    cast(price as numeric) as price,
    cast(minimum_nights as integer) as minimum_nights,
    cast(number_of_reviews as integer) as number_of_reviews,
    cast(availability_365 as integer) as availability_365
from {{ source('airbnb', 'listings') }}