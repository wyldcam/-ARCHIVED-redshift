SELECT
TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second' AS date,
sum(value) AS total_itunes_tracks
FROM timeseries_data
WHERE metric_id = 133 # metric id for iTunes track units net
GROUP BY unix_seconds
ORDER BY unix_seconds;
 
        date         | total_itunes_tracks
	---------------------+---------------------
 2014-01-01 00:00:00 |    1494049.97247317
 2014-01-02 00:00:00 |    1385720.76409159
 2014-01-03 00:00:00 |       1365117.55571
 2014-01-04 00:00:00 |    1350584.34732841
 2014-01-05 00:00:00 |    1440794.13894682
 2014-01-06 00:00:00 |    1117203.03694821
 2014-01-07 00:00:00 |     1173780.9349496
 2014-01-08 00:00:00 |    1132881.57580813
 2014-01-09 00:00:00 |    1165480.71666667
 2014-01-10 00:00:00 |     1229543.6452381
...

