{{ config(materialized='ephemeral') }}

select *
from read_parquet(
    's3://{{ env_var("AWS_BUCKET") }}/marketing/conversions/**/*.parquet',
    hive_partitioning=true
)
