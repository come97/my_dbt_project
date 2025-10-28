with listings as (
select
neighbourhood_cleansed,
room_type,
number_of_reviews,
availability_365
from {{ ref('stg_airbnb__listings') }}
),
reviews as (
select
neighbourhood_cleansed,
room_type,
sum(number_of_reviews) as total_reviews
from listings
group by 1, 2
)
select * from reviews