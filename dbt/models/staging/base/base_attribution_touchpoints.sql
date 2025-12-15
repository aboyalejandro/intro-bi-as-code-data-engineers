{{ config(materialized='ephemeral') }}

select *
from read_parquet(
    's3://{{ env_var("AWS_BUCKET") }}/marketing/attribution_touchpoints/**/*.parquet',
    hive_partitioning=true
)
