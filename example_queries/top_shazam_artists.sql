/*
This query will generate a list of the top 100 artists with the most Shazam tags between Jun. 1 2014 and Jun 30 2014.
*/

SELECT
B.entity_id,                   -- NBS id for artist
B.entity_name,                 -- NBS artist name
A.value AS total_tags          -- Total Shazam tags between 2014-06-01 and 2014-06-30
FROM (
    SELECT entity_id, sum(value) AS value
    FROM timeseries_data
    
    WHERE metric_id = ( 
        -- Select metric id for Shazam Tags
        SELECT metric_id FROM metric_data WHERE network_name = 'Shazam Feed' AND metric_name = 'Tags'
    )
    
    -- Timestamp in table is converted from unix seconds to human readable date before filtering
    AND TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second' BETWEEN '2014-06-01' and '2014-06-30'
    GROUP BY entity_id
    ORDER BY sum(value) DESC
    LIMIT 100
) A
INNER JOIN entity_data B
ON A.entity_id = B.entity_id
ORDER BY A.value DESC;

/*
Exec time: ~30 seconds
Returns:

 entity_id |    entity_name    | total_tags
-----------+-------------------+-------------------
    631063 | Nico & Vinz       |           1737756
     13145 | Pitbull           |           1725052
      3718 | Calvin Harris     |           1651390
      4153 | John Legend       |           1559806
    961366 | MAGIC!            |           1439601
    668078 | Kiesza            |           1432022
        63 | OneRepublic       |           1402204
      4805 | Michael Jackson   |           1383613
    507562 | Mr. Probz         |           1354835
    327972 | Clean Bandit      |           1315945
    263794 | Disclosure        |           1311578
     78821 | Pharrell          |           1194407
     69062 | Avicii            |           1177793
      1935 | Sia               |           1131020
      5152 | Shakira           |           1108587
    425755 | Milky Chance      |           1062485
    194289 | Imagine Dragons   |           1049537
    350146 | DJ Snake          |           1021906
      7264 | David Guetta      |            862707
       652 | Katy Perry        |            853354
       451 | Justin Timberlake |            779754
       510 | BeyoncÃ©          |            750249
    303644 | One Direction     |            702892
    268114 | Tiesto            |            696791
      5214 | Chris Brown       |            651843
... (and so on)
*/
