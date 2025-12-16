---
title: Creative Performance
---

[← Back to Overview](/)

# Ad Performance by Creative Type

<Details title="About this heatmap">

This heatmap shows the cross-dimensional performance of different creative types (image, video, carousel, etc.) across various platforms (Facebook, Google, LinkedIn, etc.). The color intensity represents total conversions, allowing you to identify which creative formats work best on each platform. This insight helps optimize your creative strategy and budget allocation across platforms.

</Details>

```sql creative_platform_performance
SELECT
    COALESCE(creative_type, 'Unknown') as creative_type,
    COALESCE(platform, 'Unknown') as platform,
    SUM(COALESCE(conversions, 0)) as total_conversions
FROM int_ads
WHERE conversions > 0
GROUP BY creative_type, platform
HAVING SUM(conversions) > 0
ORDER BY total_conversions DESC
```

<Heatmap
    data={creative_platform_performance}
    x=platform
    y=creative_type
    value=total_conversions
    valueFmt='#,##0'
    title="Creative Performance: Conversions by Platform"
/>

The best performing combination is **<Value data={creative_platform_performance} column=creative_type row=0/>** creatives on **<Value data={creative_platform_performance} column=platform row=0/>**, driving **<Value data={creative_platform_performance} column=total_conversions row=0 fmt='#,##0'/>** conversions.
