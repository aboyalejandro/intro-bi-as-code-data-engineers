---
title: Engagement Analysis
---

[← Back to Overview](/)

# Device & Session Performance

<Details title="About this chart">

This chart compares session engagement metrics across different device types (desktop, mobile, tablet). Understanding device-specific behavior patterns helps you optimize landing pages and ad creative for each platform, ensuring the best user experience regardless of how visitors access your campaigns.

</Details>

```sql device_performance
SELECT
    COALESCE(device_type, 'Unknown') as device,
    COUNT(*) as sessions,
    ROUND(AVG(pages_viewed), 1) as avg_pages,
    ROUND(AVG(time_on_site_seconds), 0) as avg_time_seconds
FROM int_sessions
WHERE device_type IS NOT NULL
GROUP BY device_type
ORDER BY sessions DESC
```

<BarChart
    data={device_performance}
    x=device
    y=sessions
    y2=avg_pages
    yFmt='#,##0'
    y2Fmt='#,##0.0'
    title="Sessions and Engagement by Device Type"
/>

```sql top_device
SELECT
    COALESCE(device_type, 'Unknown') as device,
    COUNT(*) as sessions,
    ROUND(AVG(pages_viewed), 1) as avg_pages,
    ROUND(AVG(time_on_site_seconds) / 60, 0) as avg_time_minutes
FROM int_sessions
WHERE device_type IS NOT NULL
GROUP BY device_type
ORDER BY sessions DESC
LIMIT 1
```

**<Value data={top_device} column=device/>** users lead with **<Value data={top_device} column=sessions fmt='#,##0'/>** sessions and an average of **<Value data={top_device} column=avg_pages/>** pages viewed per session, spending approximately **<Value data={top_device} column=avg_time_minutes/>** minutes on site.
