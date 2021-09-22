{{ config(materialized = 'table')}}

with first_orders as (
    select 
        customer_id,
        min(order_date) as first_order_date,
        date_trunc(min(order_date),week) as first_order_week
    from {{ref('order_items')}}
    group by 1),

weekly_skeleton as (
    select 
        first_orders.customer_id,
        first_orders.first_order_date,
        first_orders.first_order_week,
        ltv_helper.week_count
    from first_orders  
    cross join {{ref('ltv_helper_week_range')}} ltv_helper
    order by 1 asc, 3 asc),

weekly_revenue as (
select 
    weekly_skeleton.customer_id,
    weekly_skeleton.first_order_date,
    weekly_skeleton.first_order_week,
    weekly_skeleton.week_count,
    coalesce(sum(order_items.price),0) as total_revenue
from weekly_skeleton
left join {{ref('order_items')}} order_items
    on weekly_skeleton.customer_id = order_items.customer_id and 
    order_items.order_date >= date_add(weekly_skeleton.first_order_date, interval 7*(weekly_skeleton.week_count-1) day)  and 
    order_items.order_date < date_add(weekly_skeleton.first_order_date, interval 7*weekly_skeleton.week_count day)
group by 1,2,3,4
order by 1 asc, 4 asc)

select 
    customer_id,
    first_order_date,
    first_order_week,
    week_count,
    total_revenue as weekly_revenue,
    sum(total_revenue) over (partition by customer_id order by week_count asc rows unbounded preceding) as lifetime_revenue 
from weekly_revenue
order by 1 asc, 4 asc

