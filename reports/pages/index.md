---
title: Marketing Analytics Dashboard
---

Powered by **dbt** + **Evidence.dev** + **DuckDB**

## Overview Metrics

<Details title="About these metrics">

This section provides a high-level summary of your marketing campaign performance across all channels. These key metrics help you understand the scale of your marketing operations, including the total number of campaigns running, the diversity of marketing channels being utilized, the overall conversion volume, and the average effectiveness of your campaigns at driving user engagement through click-through rates.

</Details>

```sql overview_metrics
SELECT
    COUNT(DISTINCT campaign_id) as total_campaigns,
    COUNT(DISTINCT COALESCE(channel, 'Unknown')) as total_channels,
    SUM(COALESCE(total_conversions, 0)) as total_conversions,
    ROUND(AVG(COALESCE(ctr, 0)) * 100, 2) as avg_ctr_pct
FROM campaign_performance
```

<BigValue
    data={overview_metrics}
    value=total_campaigns
    fmt='#,##0'
    title="Total Campaigns"
/>

<BigValue
    data={overview_metrics}
    value=total_channels
    fmt='#,##0'
    title="Active Channels"
/>

<BigValue
    data={overview_metrics}
    value=total_conversions
    fmt='#,##0'
    title="Total Conversions"
/>

<BigValue
    data={overview_metrics}
    value=avg_ctr_pct
    fmt='#,##0.00%'
    title="Average CTR"
/>

You are currently running **<Value data={overview_metrics} column=total_campaigns/>** campaigns across **<Value data={overview_metrics} column=total_channels/>** marketing channels, generating a total of **<Value data={overview_metrics} column=total_conversions fmt='#,##0'/>** conversions with an average click-through rate of **<Value data={overview_metrics} column=avg_ctr_pct/>%**.

---

## Quick Links

- [Channel Performance](/channels) - Analyze conversion performance by marketing channel
- [Creative Performance](/creative) - Explore ad creative effectiveness across platforms
- [Conversion Timeline](/conversions) - Track conversion trends over time
- [Engagement Analysis](/engagement) - Understand user behavior across devices
