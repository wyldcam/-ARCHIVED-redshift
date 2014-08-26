/*
This query will calculate the total number of iTunes track units sold per day
*/


SELECT
TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second' AS date,
round(sum(value)) AS total_itunes_tracks
FROM timeseries_data
WHERE metric_id = (
    -- Select metric id for itunes tracks
    SELECT metric_id FROM metric_data WHERE network_name = 'iTunes' AND metric_name = 'Track Units (Net)'
)
GROUP BY unix_seconds
ORDER BY unix_seconds;

/*
Exec Time: ~20 seconds
Returns:
 
        date         | total_itunes_tracks 
---------------------+---------------------
 2014-01-01 00:00:00 |             1494050
 2014-01-02 00:00:00 |             1385721
 2014-01-03 00:00:00 |             1365118
 2014-01-04 00:00:00 |             1350584
 2014-01-05 00:00:00 |             1440794
 2014-01-06 00:00:00 |             1117203
 2014-01-07 00:00:00 |             1173781
 2014-01-08 00:00:00 |             1132882
 2014-01-09 00:00:00 |             1165481
 2014-01-10 00:00:00 |             1229544
 2014-01-11 00:00:00 |             1486171
 2014-01-12 00:00:00 |             1432013
 2014-01-13 00:00:00 |             1044214
 2014-01-14 00:00:00 |             1106103
 2014-01-15 00:00:00 |             1078838
 2014-01-16 00:00:00 |             1104150
 2014-01-17 00:00:00 |              808467
 2014-01-18 00:00:00 |              929534
 2014-01-19 00:00:00 |             1305439
 2014-01-20 00:00:00 |              990669
 2014-01-21 00:00:00 |              687311
 2014-01-22 00:00:00 |              996860
... (and so on)

*/
