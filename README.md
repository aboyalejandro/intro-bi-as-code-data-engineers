# BI-as-Code: Marketing Analytics

A modern analytics stack using **dbt** + **PostgreSQL** + **Evidence.dev** to transform raw marketing data into interactive dashboards.

## Architecture

```
PostgreSQL (raw schema)
         │
         ▼
    dbt + PostgreSQL
    (transforms & models)
         │
         ▼
PostgreSQL (analytics schema)
         │
         ▼
    Evidence.dev
    (interactive dashboards)
```

## Project Structure

```
.
├── dbt/                          # dbt project
│   ├── models/
│   │   ├── staging/              # Staging transforms
│   │   ├── intermediate/         # Business logic
│   │   └── marts/                # Final tables
│   ├── profiles.yml              # PostgreSQL connection
│   └── dbt_project.yml
│
├── reports/                      # Evidence.dev project
│   ├── pages/                    # Dashboard pages
│   │   ├── index.md              # Overview
│   │   ├── channels.md           # Channel performance
│   │   ├── creative.md           # Ad creative analysis
│   │   ├── conversions.md        # Conversion timeline
│   │   └── engagement.md         # Device engagement
│   └── sources/marketing/        # PostgreSQL connection
│
└── .env                          # PostgreSQL credentials
```

## Prerequisites

- Python 3.9+
- Node.js 18+
- PostgreSQL database with source tables

## Setup

### 1. Clone and create virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
pip install dbt-postgres
```

### 2. Configure environment variables

Copy `.env.example` to `.env` and fill in your PostgreSQL credentials:

```bash
cp .env.example .env
```

Required variables:
```
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_DB=marketing
```

### 3. Run dbt

```bash
cd dbt
source ../.env
export POSTGRES_HOST POSTGRES_PORT POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB
dbt run --profiles-dir .
```

### 4. Start Evidence

```bash
cd reports
npm install
npm run sources
npm run dev
```

Open http://localhost:3000 to view the dashboards.

## Data Models

### Sources (PostgreSQL raw schema)
- `campaigns_daily` - Daily campaign metrics
- `ad_creatives` - Creative-level performance
- `sessions` - User website sessions
- `conversions` - Purchase events
- `attribution_touchpoints` - Multi-touch attribution

### Marts (Final Tables)
| Table | Description |
|-------|-------------|
| `campaign_performance` | Campaign metrics with sessions & conversions |
| `channel_attribution` | Multi-touch attribution by channel |
| `daily_summary` | Daily rollup of all metrics |
| `user_journey` | User-level journey analysis |
| `int_ads` | Ad creative performance |
| `int_sessions` | Session engagement data |
| `int_conversions` | Conversion details |

## Dashboards

| Page | Description |
|------|-------------|
| **Overview** | KPIs: campaigns, channels, conversions, CTR |
| **Channels** | Conversion performance by marketing channel |
| **Creative** | Heatmap of creative types vs platforms |
| **Conversions** | Daily conversion timeline by channel |
| **Engagement** | Device-based session analysis |

## Development

### Rebuild models
```bash
cd dbt
dbt run --profiles-dir .
```

### Run tests
```bash
dbt test --profiles-dir .
```

### Full refresh
```bash
dbt run --profiles-dir . --full-refresh
```

## License

MIT
