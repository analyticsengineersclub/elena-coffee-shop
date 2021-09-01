{{ config (
    materialized = 'table'
)}}

with customer_orders as (
    select  customer_id,
            min(created_at) as first_order_at,
            count(distinct id) as number_of_orders 
    from `analytics-engineers-club.coffee_shop.orders`
    group by 1 
    order by 1)

select  customers.id as customer_id,
        customers.name,
        customers.email,
        customer_orders.first_order_at,
        customer_orders.number_of_orders 
from `analytics-engineers-club.coffee_shop.customers` customers 
inner join customer_orders
on customers.id = customer_orders.customer_id
order by 4 asc