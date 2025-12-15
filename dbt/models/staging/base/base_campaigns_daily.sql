{{ config(materialized='ephemeral') }}

select *
from read_parquet(
    's3://{{ env_var("AWS_BUCKET") }}/marketing/campaigns_daily/**/*.parquet',
    hive_partitioning=true
)
