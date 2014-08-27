/*
This query will calculate the average number of Spotify streams per day of week (i.e. Mon, Tue, Wed, etc.)
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
A.average_streams
FROM (
    SELECT
    -- Determine day of week number from unix seconds timestamp
    EXTRACT(dow FROM TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second') AS day_of_week,
    avg(value) AS average_streams
    FROM timeseries_data 
    WHERE metric_id = (
        -- Get metric id for Spotify streams (aka 'Plays')
        SELECT metric_id FROM metric_data WHERE network_name = 'Spotify Feed' AND metric_name = 'Plays'
    )
    GROUP BY day_of_week
) A
INNER JOIN dow B
ON A.day_of_week = B.day_number
ORDER BY A.day_of_week;

/*
Exec Time: ~20 seconds
Returns:

 day_name  | average_streams  
-----------+------------------
 Sunday    | 1530.99179543757
 Monday    | 1728.70416121657
 Tuesday   | 1786.62796599267
 Wednesday | 1797.51284836113
 Thursday  | 1814.03093763506
 Friday    | 1863.78802569902
 Saturday  | 1672.2431746271
(7 rows)
*/
