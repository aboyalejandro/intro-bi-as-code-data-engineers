with source as (
    select * from {{ ref('base_attribution_touchpoints') }}
),

cleaned as (
    select
        touchpoint_id,
        session_id,
        user_id,
        campaign_id,
        channel,
        touchpoint_position,
        timestamp

    from source
)

select * from cleaned
