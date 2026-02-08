# Marketing Analytics dbt Project

This dbt project transforms marketing data in PostgreSQL, providing analytics-ready models for the Evidence.dev dashboards.

## Architecture

```
S3 (Parquet files)
    ↓ (DuckDB loader in seed.py)
PostgreSQL (raw data in marketing schema)
    ↓ (dbt transformations)
PostgreSQL (marts in marketing schema)
    ↓
Evidence.dev (dashboards)
```

**Note:** DuckDB is only used in `seed.py` to load data from S3 into PostgreSQL. All dbt transformations run on PostgreSQL.

## Prerequisites

- Docker (for PostgreSQL container)
- Python 3.8+
- dbt-postgres installed

## Setup

### 1. Install Dependencies

From the root directory:

```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies (dbt-postgres, psycopg2, duckdb for seeding)
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
```

### 2. Start PostgreSQL and Load Data

```bash
# Start PostgreSQL, seed data from S3, and run dbt transformations
docker compose up
```

This will:
1. Start PostgreSQL on port 5432
2. Run `seed.py` to load data from public S3 bucket (no credentials needed)
3. Run dbt to create staging and mart tables

### 3. Verify the Setup

```bash
# Check that tables were created
docker exec -it marketing-postgres psql -U postgres -d marketing -c "\dt marketing.*"
```

You should see tables like:
- `marketing.campaigns_daily`
- `marketing.sessions`
- `marketing.conversions`
- `marketing.attribution_touchpoints`
- `marketing.campaign_performance` (dbt mart)
- `marketing.channel_attribution` (dbt mart)

## Project Structure

```
dbt/marketing_analytics/
├── models/
│   ├── staging/           # Cleaned source data
│   │   ├── _sources.yml   # Source definitions
│   │   ├── stg_campaigns_daily.sql
│   │   ├── stg_sessions.sql
│   │   ├── stg_conversions.sql
│   │   └── stg_attribution_touchpoints.sql
│   │
│   └── marts/             # Business-ready analytics tables
│       ├── campaign_performance.sql    # Campaign metrics with conversions
│       ├── user_journey.sql            # User journey analysis
│       ├── channel_attribution.sql     # Attribution by channel
│       └── daily_summary.sql           # Daily rollup metrics
│
├── dbt_project.yml        # Project configuration
└── profiles.yml           # PostgreSQL connection (uses env vars from Docker)
```

## Running dbt Manually

If you want to run dbt outside of Docker:

```bash
cd dbt/marketing_analytics

# Set PostgreSQL environment variables
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export POSTGRES_DB=marketing

# Run all models
dbt run --profiles-dir ../
```

### Run Specific Models

```bash
# Run only staging models
dbt run --select staging.* --profiles-dir ../

# Run only marts
dbt run --select marts.* --profiles-dir ../

# Run a specific model
dbt run --select campaign_performance --profiles-dir ../
```

### Test Data Quality

```bash
dbt test --profiles-dir ../
```

### Generate Documentation

```bash
dbt docs generate --profiles-dir ../
dbt docs serve --profiles-dir ../
```

## Models Overview

### Staging Models

Clean and standardize raw data from the marketing schema:

- **stg_campaigns_daily**: Campaign performance with calculated CTR and CPC
- **stg_sessions**: Session data with engagement levels and page depth
- **stg_conversions**: Conversion data with value tiers
- **stg_attribution_touchpoints**: Attribution touchpoint data

### Mart Models

Business-ready analytics tables for Evidence.dev dashboards:

#### campaign_performance
Complete campaign performance metrics:
- Spend, impressions, clicks, CTR, CPC
- Sessions, users, engagement
- Conversions, revenue
- Calculated metrics: conversion rate, ROAS, CPA

#### user_journey
User journey analysis:
- Touchpoint count per user
- Campaign and channel diversity
- Journey length and conversion status
- User classification (multi-channel, converted, etc.)

#### channel_attribution
Multi-touch attribution by channel:
- First-touch, last-touch, and linear attribution
- Revenue by attribution model
- Conversion counts per model

#### daily_summary
Daily rollup of all metrics:
- Active campaigns and channels
- Total spend, impressions, clicks
- Session and user metrics
- Overall conversion rate and ROAS

## Example Queries

Connect to PostgreSQL and query the dbt models:

```bash
docker exec -it marketing-postgres psql -U postgres -d marketing
```

```sql
-- Top performing campaigns by ROAS
SELECT
    campaign_name,
    channel,
    total_spend,
    total_revenue,
    roas,
    conversion_rate
FROM marketing.campaign_performance
WHERE roas > 1.5
ORDER BY roas DESC
LIMIT 10;

-- Channel attribution comparison
SELECT
    channel,
    first_touch_revenue,
    last_touch_revenue,
    linear_revenue,
    first_touch_conversions,
    last_touch_conversions
FROM marketing.channel_attribution
ORDER BY linear_revenue DESC;

-- Daily performance trends
SELECT
    date,
    total_spend,
    total_revenue,
    overall_roas,
    overall_conversion_rate,
    total_sessions
FROM marketing.daily_summary
ORDER BY date DESC
LIMIT 30;
```

## Development Workflow

1. **Make changes** to models in `models/`
2. **Rebuild**: `docker compose up --build dbt`
3. **Test**: `dbt test --profiles-dir ../`
4. **View in Evidence.dev**: `cd reports && npm run dev`
5. **Generate docs**: `dbt docs generate --profiles-dir ../`

## Troubleshooting

### Connection Issues

```bash
# Test dbt connection
cd dbt/marketing_analytics
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export POSTGRES_DB=marketing
dbt debug --profiles-dir ../
```

### Reset Everything

```bash
# Stop containers and delete all data
docker compose down -v

# Start fresh
docker compose up
```

### Check PostgreSQL Logs

```bash
docker logs marketing-postgres
docker logs marketing-seeder
docker logs marketing-dbt
```

## Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt-postgres Adapter](https://docs.getdbt.com/reference/warehouse-setups/postgres-setup)
- [Evidence.dev Documentation](https://docs.evidence.dev/)
