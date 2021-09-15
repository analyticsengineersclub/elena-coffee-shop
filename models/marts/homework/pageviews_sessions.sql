with timedifferences as (
    select 
        pageview_id,
        timestamp,
        visitor_id,
        customer_id,
        page,
        device_type,
        lag(timestamp,1) over (partition by visitor_id order by timestamp asc) as previous_timestamp
    from {{ref ('pageviews')}}
    order by visitor_id asc, timestamp asc ),

sessions_count as (
    select 
        pageview_id,
        timestamp,
        visitor_id,
        customer_id,
        page,
        device_type,
        previous_timestamp,
        case when  
            previous_timestamp is NULL or 
            timestamp_diff(timestamp, previous_timestamp,minute) > 30 then 1 
            else 0 end as is_new_session
    from timedifferences
    order by visitor_id asc, timestamp asc),

session_ids as 
(   select 
        pageview_id,
        timestamp,
        visitor_id,
        customer_id,
        page,
        device_type,
        SUM(is_new_session) over (order by visitor_id asc, timestamp asc) as session_id 
from sessions_count)

select 
a.pageview_id,
a.timestamp,
a.visitor_id,
a.customer_id,
a.page,
a.device_type,
a.session_id,
min(b.timestamp) as session_start_at,
max(b.timestamp) as session_end_at 

from session_ids a 
join session_ids b 
on a.session_id = b.session_id 
group by 1,2,3,4,5,6,7
order by 7 asc, 2 asc 