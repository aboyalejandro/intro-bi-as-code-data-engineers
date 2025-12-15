{{ config(materialized='table') }}

with ad_creatives as (
    select * from {{ ref('base_ad_creatives') }}
),

sessions as (
    select * from {{ ref('base_sessions') }}
),

conversions as (
    select * from {{ ref('base_conversions') }}
),

-- Count conversions by creative through sessions
creative_conversions as (
    select
        s.creative_id,
        count(c.conversion_id) as conversion_count,
        sum(c.conversion_value) as total_conversion_value
    from sessions s
    inner join conversions c on s.session_id = c.session_id
    group by s.creative_id
),

ads_with_metrics as (
    select
        a.creative_id as ad_id,
        a.campaign_id,
        a.creative_name as ad_name,
        a.creative_type,
        a.channel as platform,
        'feed' as placement,
        sum(a.impressions) as impressions,
        sum(a.clicks) as clicks,
        case when sum(a.impressions) > 0 then sum(a.clicks)::float / sum(a.impressions)::float else 0 end as ctr,
        sum(a.spend) as spend,
        case when sum(a.clicks) > 0 then sum(a.spend) / sum(a.clicks) else 0 end as avg_cpc,
        coalesce(cc.conversion_count, 0) as conversions,
        case when coalesce(cc.conversion_count, 0) > 0 then sum(a.spend) / cc.conversion_count else 0.0 end as cpa,
        min(a.date) as start_date,
        max(a.date) as end_date,
        'active' as ad_status,
        null as targeting,
        max(a.date) as last_updated
    from ad_creatives a
    left join creative_conversions cc on a.creative_id = cc.creative_id
    group by a.creative_id, a.campaign_id, a.creative_name, a.creative_type, a.channel, cc.conversion_count
)

select * from ads_with_metrics
