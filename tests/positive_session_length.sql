-- session end should always be equal or more than zero
-- therefore return records where session end is before session start

select distinct session_id
from {{ref ('pageviews_sessions')}}
where session_end_at < session_start_at