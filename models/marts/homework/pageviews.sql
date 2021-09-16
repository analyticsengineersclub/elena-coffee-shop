with pageviews as (
    select * from {{ ref('stg_web_tracking__pageviews')}}
),

ordered_pageviews as (
    select 
        customer_id,
        visitor_id,
        timestamp,
        row_number() over (partition by customer_id order by timestamp asc) as pageview_order
    from pageviews 
    where customer_id is not null)

    select 
    pageviews.pageview_id,
    pageviews.timestamp,
    pageviews.customer_id,
    case when 
        pageviews.customer_id is null then pageviews.visitor_id 
    else
        ordered_pageviews.visitor_id end as visitor_id,
    pageviews.page,
    pageviews.device_type
from pageviews 
left join ordered_pageviews on
    pageviews.customer_id = ordered_pageviews.customer_id and
    pageview_order = 1