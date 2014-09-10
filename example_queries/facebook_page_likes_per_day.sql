/*
This query will calculate the total number of Facebook Page Likes occurring each day
*/


SELECT
TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second' AS date,
round(sum(value)) AS total_fb_page_likes
FROM timeseries_data
WHERE metric_id = (
    -- Select metric id for Facebook Page Likes
    SELECT metric_id FROM metric_data WHERE network_name = 'Facebook' AND metric_name = 'Page Likes'
)
-- Need to restrict results to daily changes, not lifetime totals
AND count_type = 'd'
GROUP BY unix_seconds
ORDER BY unix_seconds;

/*
Exec Time: ~20 seconds
Returns:
 
        date         | total_fb_page_likes 
---------------------+---------------------
 2014-01-01 00:00:00 |            16530548
 2014-01-02 00:00:00 |            18917459
 2014-01-03 00:00:00 |            20173281
 2014-01-04 00:00:00 |            19449514
 2014-01-05 00:00:00 |            18830701
 2014-01-06 00:00:00 |            11235777
 2014-01-07 00:00:00 |            36459922
... (and so on)

*/
