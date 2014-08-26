SELECT
EXTRACT(dow FROM TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second') AS day_of_week,
avg(value) AS average_value,
stddev(value) AS stddev_value
FROM timeseries_data
WHERE metric_id = 100 # metric id for Spotify streams
GROUP BY day_of_week
ORDER BY day_of_week;
 
# day 0 = Sunday, 1 = Monday, etc.
 day_of_week |  average_value   |   stddev_value  
-------------+------------------+------------------
           0 | 5897.46009074449 | 44290.6571516676
           1 | 6553.77964922741 | 48487.4599980937
           2 | 6800.99065134053 | 50108.8678166438
           3 | 6835.42546990926 | 50558.8823588478
           4 | 6929.48767721098 | 50981.0703324225
           5 | 7144.51372142668 | 52955.0293031299
           6 | 6522.50112848708 | 49503.7711157207
