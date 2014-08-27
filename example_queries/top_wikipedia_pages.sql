/*
This query will generate a list of the top 100 artists with the most Wikipedia page views between Jun. 1 2014 and Jun 30 2014.
*/

SELECT
B.entity_id,                   -- NBS id for artist
B.entity_name,                 -- NBS artist name
round(A.value) AS total_views  -- Total Wiki views between 2014-06-01 and 2014-06-30
FROM (
    SELECT entity_id, sum(value) AS value
    FROM timeseries_data
    
    WHERE metric_id = ( 
        -- Select metric id for Wikipedia Page Views
        SELECT metric_id FROM metric_data WHERE network_name = 'Wikipedia' AND metric_name = 'Pageviews'
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

 entity_id |         entity_name          | total_views 
-----------+------------------------------+-------------
    754729 | FIFA World Cup 2014          |     8181880
    315386 | Game Of Thrones              |     3819533
    300662 | Facebook (Company)           |     3053924
    327432 | Amazon                       |     2816128
    339932 | Lionel AndrÃ©s Messi         |     2439057
      8859 | YouTube                      |     2147223
     97157 | Wikipedia                    |     1687645
    303484 | Google                       |     1640243
    782294 | Megan Bostic                 |     1534547
    327010 | Iggy Azalea                  |     1407096
    339905 | Rafael Nadal                 |     1244013
    236433 | Ariana Grande                |     1229602
    990059 | Adolf Hitler                 |     1225977
      6387 | Jennifer Lopez               |     1206366
    989554 | Boris Fausto                 |     1168107
      4805 | Michael Jackson              |     1138191
      5152 | Shakira                      |     1130787
    303701 | Lana Del Rey                 |     1098054
    325088 | Breaking Bad                 |     1096697
      3886 | Eminem                       |     1022114
    998442 | Angelina Jolie               |     1004018
    121112 | The United States of America |     1001168
... (and so on)
*/
