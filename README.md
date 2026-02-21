# 📊 BI as Code: Marketing Analytics with Evidence.dev

Interactive marketing dashboards built entirely with SQL and Markdown — powered by **dbt** + **PostgreSQL** + **Evidence.dev**.

A BI-as-Code stack that:
- Seeds synthetic marketing data from a public S3 bucket into PostgreSQL using DuckDB
- Runs dbt transformations (staging → intermediate → marts)
- Serves interactive dashboards through Evidence.dev — just SQL queries inside Markdown files
- Runs locally with Docker Compose, no cloud accounts needed

<img width="741" height="424" alt="dashboard-overview" src="https://github.com/user-attachments/assets/693aef0a-6adf-4a23-8e97-ddb17fa19b5d" />

## 🙋🏻‍♂️ Prerequisites

- Docker Desktop
- Node.js 18+

## 📝 Steps

### 1. Start database, seed data and run dbt

```bash
docker compose up
```

This starts:
- PostgreSQL with ~400K rows from S3
- dbt (17 analytics models)
- Evidence.dev-ready data in `marketing` schema

### 2. Configure Evidence connection (one-time setup)

```bash
cp reports/sources/marketing/connection.yaml.example reports/sources/marketing/connection.yaml
```

The default values match the Docker Compose setup:

```yaml
name: marketing
type: postgres
options:
  host: localhost
  port: 5432
  user: postgres
  password: postgres
  database: marketing
```

### 3. Start the dashboard

On another terminal, run:

```bash
cd reports && npm install && npm run sources && npm run dev
```

Open http://localhost:3000

## 🏗️ Architecture

```
S3 (Parquet files)
    ↓
Docker Compose
├── PostgreSQL (raw data)
├── Seeder (S3 → Postgres via DuckDB)
└── dbt (17 models: staging → intermediate → marts)
         ↓
Evidence.dev (local) → localhost:3000
```

```text
├── dbt/
│   └── models/
│       ├── staging/           # Clean and standardize raw tables
│       ├── intermediate/      # Business logic and enrichment
│       └── marts/             # Final aggregations for dashboards
├── reports/
│   └── pages/
│       ├── index.md           # Overview with KPIs
│       ├── channels.md        # Channel performance
│       ├── conversions.md     # Conversion timeline
│       ├── creative.md        # Creative analysis
│       └── engagement.md      # Session & device analysis
├── config.py                  # S3 bucket and table configuration
├── seed.py                    # DuckDB-based S3 → PostgreSQL seeder
├── docker-compose.yml
├── Dockerfile
└── requirements.txt
```

## 📈 Dashboards

| Page | Description |
|------|-------------|
| **Overview** | KPIs: campaigns, channels, conversions, CTR |
| **Channels** | Conversion performance by marketing channel |
| **Creative** | Heatmap of creative types vs platforms |
| **Conversions** | Daily conversion timeline by channel |
| **Engagement** | Device-based session analysis |

## 🧹 Cleanup

```bash
docker compose down -v
```

### 😎 Follow me on [Linkedin](https://linkedin.com/in/alejandro-aboy)
- Get tips, learnings and tricks for your Data career!

### 📩 Subscribe to [The Pipe & The Line](https://thepipeandtheline.substack.com)
- Join the Substack newsletter to get similar content to this one and more to improve your Data career!
