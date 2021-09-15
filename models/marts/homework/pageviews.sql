with pageviews as (
    select * from {{ ref('stg_web_tracking__pageviews')}}
),

first_visit as (
    select 
        customer_id,
        min(timestamp) as first_visit_timestamp
    from pageviews 
    where customer_id is not null
    group by 1
    order by 1),

    first_visitor_id as (
    select 
        first_visit.customer_id, 
        first_visit.first_visit_timestamp,
        pageviews.visitor_id 
    from first_visit
    left join pageviews on
        first_visit.customer_id = pageviews.customer_id and
        first_visit.first_visit_timestamp = pageviews.timestamp)

    select pageviews.pageview_id,
            pageviews.timestamp,
            pageviews.customer_id,
            first_visitor_id.visitor_id,
            pageviews.device_type,
            pageviews.page 
    from pageviews 
    left join first_visitor_id on 
        pageviews.customer_id = first_visitor_id.customer_id 