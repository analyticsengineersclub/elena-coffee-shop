with order_weeks as (
    select 
        distinct date_trunc(created_at, week) as order_week 
    from {{ref ('stg_coffee_shop__orders')}}
    order by 1 asc)

select 
    order_week, 
    row_number() over(order by order_week asc) as week_count
from order_weeks
order by 1 asc
