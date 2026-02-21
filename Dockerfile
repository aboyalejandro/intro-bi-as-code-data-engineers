FROM python:3.11-slim AS base

WORKDIR /app

# Install system dependencies for postgres and compilation
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Install all dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Seeder stage
FROM base AS seeder
COPY config.py seed.py ./
CMD ["python3", "seed.py"]

# dbt stage
FROM base AS dbt
COPY dbt/ ./dbt/
WORKDIR /app/dbt
CMD ["dbt", "run", "--profiles-dir", "."]
