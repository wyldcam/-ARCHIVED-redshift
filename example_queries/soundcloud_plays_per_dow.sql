/*
This query will calculate the average number of SoundCloud track plays per day of week (i.e. Mon, Tue, Wed, etc.)
*/


-- Create mapping of day numbers to day names
CREATE TEMP TABLE dow (
day_number integer,
day_name varchar(24)
);

INSERT INTO dow VALUES
(0, 'Sunday'),(1, 'Monday'),(2, 'Tuesday'),
(3, 'Wednesday'),(4, 'Thursday'),(5, 'Friday'),(6, 'Saturday');


-- Compute averages per day number and join to mapping above
SELECT 
B.day_name,
A.average_plays
FROM (
    SELECT
    -- Determine day of week number from unix seconds timestamp
    EXTRACT(dow FROM TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second') AS day_of_week,
    avg(value) AS average_streams
    FROM timeseries_data 
    WHERE metric_id = (
        -- Get metric id for SoundCloud track plays
        SELECT metric_id FROM metric_data WHERE network_name = 'SoundCloud' AND metric_name = 'Plays'
    )
    GROUP BY day_of_week
) A
INNER JOIN dow B
ON A.day_of_week = B.day_number
ORDER BY A.day_of_week;

/*
Exec Time: ~20 seconds
Returns:

 day_name  | average_plays  
-----------+------------------
 Sunday    | 36565.8932738619
 Monday    | 36782.7322500095
 Tuesday   | 36918.4746420169
 Wednesday | 36716.1385097271
 Thursday  | 36848.9883889145
 Friday    | 36828.3448396568
 Saturday  | 36447.2542176543
(7 rows)
*/
