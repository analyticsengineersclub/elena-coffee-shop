with 

orders as (
    select * from {{ ref('stg_coffee_shop__orders')}}
),

order_items as (
    select * from {{ ref('stg_coffee_shop__order_items')}}
),

product_prices as (
    select * from {{ ref('stg_coffee_shop__product_prices')}}
),


final as (
select 
    order_items.order_item_id,
    order_items.order_id,
    order_items.product_id,
    orders.created_at as order_date,
    orders.customer_id,
    product_prices.price,
    dense_rank() over (partition by orders.customer_id order by orders.customer_id, orders.created_at asc) as customer_order_count  

from order_items

left join orders on order_items.order_id = orders.order_id 

left join product_prices on 
        order_items.product_id = product_prices.product_id and
        orders.created_at >= product_prices.created_at and
        orders.created_at < product_prices.ended_at)

select * from final where price is not null