---
title: Conversion Timeline
---

[← Back to Overview](/)

# Conversion Timeline Analysis

<Details title="About this chart">

This chart visualizes daily conversion volume trends over time by channel, helping you identify patterns, seasonality, and the impact of campaign launches or optimizations. The stacked bars make it easy to spot spikes or dips in conversion activity and understand overall momentum across different marketing channels.

</Details>

```sql conversions_over_time
SELECT
    CAST(conversion_time AS DATE) as date,
    COALESCE(conversion_channel, 'Unknown') as channel,
    COUNT(*) as conversions
FROM int_conversions
WHERE conversion_time IS NOT NULL
    AND conversion_time >= '2025-01-01'
GROUP BY CAST(conversion_time AS DATE), conversion_channel
ORDER BY date, channel
```

<BarChart
    data={conversions_over_time}
    x=date
    y=conversions
    series=channel
    yFmt='#,##0'
    title="Daily Conversions by Channel"
/>

```sql total_conversions_2025
SELECT
    COUNT(*) as total,
    COUNT(DISTINCT conversion_channel) as channels
FROM int_conversions
WHERE conversion_time >= '2025-01-01'
```

Since the start of 2025, you've generated **<Value data={total_conversions_2025} column=total fmt='#,##0'/>** conversions across **<Value data={total_conversions_2025} column=channels/>** different channels.
