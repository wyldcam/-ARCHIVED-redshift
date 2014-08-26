/*
This query will calculate the average number of Spotify streams per day of week (i.e. Mon, Tue, Wed, etc.)
*/


-- Create mapping of day numbers to day names
CREATE TEMP TABLE dow (
day_number integer,
day_name varchar(24)
)
INSERT INTO dow VALUES
(0, 'Sunday'),(1, 'Monday'),(2, 'Tuesday'),
(3, 'Wednesday'),(4, 'Thursday'),(5, 'Friday'),(6, 'Saturday');


-- Compute averages per day number and join to mapping above
SELECT 
B.day_name,
A.average_streams
FROM (
    SELECT
    -- Determine day of week number from unix seconds timestamp
    EXTRACT(dow FROM TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second') AS day_of_week,
    avg(value) AS average_streams
    FROM timeseries_data 
    WHERE metric_id = (
        -- Get metric id for Spotify streams (aka 'Plays')
        SELECT metric_id FROM metric_data WHERE network_name = 'Spotify' AND metric_name = 'Plays'
    )
    GROUP BY day_of_week
) A
INNER JOIN dow B
ON A.day_of_week = B.day_number
ORDER BY A.day_of_week;

/*
Exec Time: ~30 seconds
Returns:

 day_name  | average_streams  
-----------+------------------
 Sunday    | 5851.03719540402
 Monday    | 6553.77964922741
 Tuesday   | 6800.99065134053
 Wednesday | 6835.42546990926
 Thursday  | 6929.48767721098
 Friday    | 7144.51372142668
 Saturday  | 6478.44120373102
*/
