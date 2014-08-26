SELECT
B.entity_id,
B.entity_name,
A.value AS total_video_views
FROM (
	  SELECT entity_id, sum(value) AS value
	  FROM timeseries_data
	  WHERE metric_id = 348 # metric id for Shazam tags
	  AND TIMESTAMP WITH Time Zone 'epoch' + unix_seconds * INTERVAL '1 second' BETWEEN '2014-06-01' and '2014-06-30'
	  GROUP BY entity_id
	  ORDER BY sum(value) DESC
	  LIMIT 25
) A
INNER JOIN entity_data B
ON A.entity_id = B.entity_id
ORDER BY A.value DESC;
