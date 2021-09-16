-- there can't be a purchase without a pageview and there can't be more unique pageviews than total pageviews
-- therefore return records where one of these conditions isn't met

select session_id, 
        total_pageviews,
        unique_pages,
        total_purchases
from {{ref ('sessions')}} 
where unique_pages > total_pageviews OR total_purchases > total_pageviews 