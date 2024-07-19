-- Query Example 1: Count shows by genre 
WITH split_genres
     AS (SELECT show_id,
                title,
                Trim(value) AS genre
         FROM   shows
                CROSS JOIN Unnest(String_to_array(listed_in, ',')) AS t(value))
SELECT genre,
       Count(*) AS show_count
FROM   split_genres
GROUP  BY genre
ORDER  BY show_count DESC; 