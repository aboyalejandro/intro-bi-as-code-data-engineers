"""
Configuration for seeding PostgreSQL from public S3 bucket.
"""

import os

# Public S3 bucket (no credentials required)
S3_BUCKET = "s3://synthetic-data-lakehouse/marketing"

# Marketing tables to seed
TABLES = [
    "campaigns_daily",
    "ad_creatives",
    "sessions",
    "conversions",
    "attribution_touchpoints"
]

# PostgreSQL configuration (Docker defaults)
POSTGRES_CONFIG = {
    "host": os.getenv("POSTGRES_HOST", "localhost"),
    "port": int(os.getenv("POSTGRES_PORT", "5432")),
    "database": os.getenv("POSTGRES_DB", "marketing"),
    "user": os.getenv("POSTGRES_USER", "postgres"),
    "password": os.getenv("POSTGRES_PASSWORD", "postgres")
}
