# BI-as-Code: Marketing Analytics

Interactive marketing dashboards powered by **dbt** + **PostgreSQL** + **Evidence.dev**.

Loads synthetic marketing data from a public S3 bucket, transforms it with dbt, and serves it through Evidence.dev.

<img width="741" height="424" alt="Captura de pantalla 2026-01-31 a las 23 27 28" src="https://github.com/user-attachments/assets/693aef0a-6adf-4a23-8e97-ddb17fa19b5d" />

## Prerequisites

- Docker
- Node.js 18+

## Setup

```bash
# 1. Start database and load data
docker compose up
```

**2. Configure Evidence connection (one-time setup)**

Copy the example file:
```bash
cp reports/sources/marketing/connection.yaml.example reports/sources/marketing/connection.yaml
```

Then edit `reports/sources/marketing/connection.yaml` with these values:

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

**3. Start the dashboard**

```bash
cd reports && npm install && npm run sources && npm run dev
```

Open http://localhost:3000

## Architecture

```
Docker Compose
├── PostgreSQL (raw data)
├── Seeder (loads from S3)
└── dbt (transforms data)
         ↓
Evidence.dev (local) → localhost:3000
```

## Dashboards

| Page | Description |
|------|-------------|
| **Overview** | KPIs: campaigns, channels, conversions, CTR |
| **Channels** | Conversion performance by marketing channel |
| **Creative** | Heatmap of creative types vs platforms |
| **Conversions** | Daily conversion timeline by channel |
| **Engagement** | Device-based session analysis |

## Reset Everything

```bash
docker compose down -v
```
