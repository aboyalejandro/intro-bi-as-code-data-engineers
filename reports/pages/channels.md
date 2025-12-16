---
title: Channel Performance
---

[← Back to Overview](/)

# Channel Performance Analysis

<Details title="About this analysis">

This section breaks down total conversions by marketing channel, allowing you to quickly identify which channels are delivering the most value. By comparing conversion volumes across email, social, search, display, and other channels, you can make data-driven decisions about where to allocate your marketing budget and resources for maximum impact.

</Details>

```sql channel_performance
SELECT
    DISTINCT COALESCE(channel, 'Unknown') as channel,
    SUM(COALESCE(total_conversions, 0)) as total_conversions
FROM campaign_performance
GROUP BY channel
ORDER BY total_conversions DESC
```

<BarChart
    data={channel_performance}
    x=channel
    y=total_conversions
    type=grouped
    swapXY=true
/>

Your top performing channel is **<Value data={channel_performance} column=channel row=0/>** with **<Value data={channel_performance} column=total_conversions row=0 fmt='#,##0'/>** conversions, accounting for a significant portion of your marketing success.
