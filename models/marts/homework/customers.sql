with 

orders as (
    select * from {{ ref('stg_coffee_shop__orders')}}
),

customers as (
    select * from {{ ref('stg_coffee_shop__customers')}}
),

customer_orders as (
    select  customer_id,
            min(created_at) as first_order_at,
            count(distinct order_id) as number_of_orders 
    from orders
    group by 1 
    order by 1)

select  customers.customer_id,
        customers.name,
        customers.email,
        customer_orders.first_order_at,
        customer_orders.number_of_orders 
from customers
inner join customer_orders
on customers.customer_id = customer_orders.customer_id
order by 4 asc