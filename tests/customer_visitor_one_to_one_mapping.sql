-- after user stiching each customer_id in pageviews model should have only one visitor_id
-- therefore return records where this isn't true to make test fail

select customer_id, count(distinct visitor_id) as total_visitor_id
from {{ref ('pageviews')}}
where customer_id is not null
group by 1 
having total_visitor_id > 1