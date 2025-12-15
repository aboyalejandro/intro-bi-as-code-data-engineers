{{ config(materialized='table') }}

with conversions as (
    select * from {{ ref('base_conversions') }}
),

sessions as (
    select * from {{ ref('base_sessions') }}
),

conversions_with_details as (
    select
        c.conversion_id,
        c.session_id,
        c.user_id as visitor_id,
        c.attributed_campaign_id as campaign_id,
        s.creative_id as ad_id,
        c.timestamp as conversion_time,
        'purchase' as conversion_type,
        c.conversion_value,
        c.conversion_value as revenue,
        c.attribution_model,
        0.0 as attributed_spend,
        0.0 as cpa,
        s.channel as conversion_channel,
        true as is_revenue_confirmed,
        'ORD-' || c.conversion_id as order_id
    from conversions c
    left join sessions s on c.session_id = s.session_id
)

select * from conversions_with_details
