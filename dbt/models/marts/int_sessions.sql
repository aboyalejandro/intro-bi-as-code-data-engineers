{{ config(materialized='table') }}

with sessions as (
    select * from {{ source('marketing_raw', 'sessions') }}
),

sessions_formatted as (
    select
        session_id,
        user_id as visitor_id,
        campaign_id,
        creative_id as ad_id,
        channel || ' / organic' as source_medium,
        '/' as landing_page,
        session_start,
        session_start + (session_duration_sec * interval '1 second') as session_end,
        pages_viewed,
        session_duration_sec as time_on_site_seconds,
        case when session_duration_sec < 10 and pages_viewed <= 1 then true else false end as bounce,
        device_type,
        'Chrome' as browser
    from sessions
)

select * from sessions_formatted
