FROM python:3.11-slim as base

WORKDIR /app

# Install all dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Seeder stage
FROM base as seeder
COPY config.py seed.py ./
CMD ["python3", "seed.py"]

# dbt stage
FROM base as dbt
COPY dbt/ ./dbt/
WORKDIR /app/dbt
CMD ["dbt", "run", "--profiles-dir", "."]
