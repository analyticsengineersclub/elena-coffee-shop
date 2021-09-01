select 
    date_trunc(first_order_at, month) as month,
    count(customer_id) as new_customers
from {{ ref ('customers')}}
group by 1
order by 1 asc