select 
    session_id,
    session_start_at,
    session_end_at,
    timestamp_diff(session_end_at,session_start_at,second) as session_length_seconds,
    count(pageview_id) as total_pageviews,
    count(distinct page) as unique_pages,
    count(case when page = 'order-confirmation' then pageview_id end) as total_purchases
from {{ ref('pageviews_sessions')}}
group by 1,2,3,4
order by 1 asc
