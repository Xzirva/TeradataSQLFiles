select distinct s.id, max(s.dseconds) from((select id, duration, CAST (substr(duration, 3, (POSITION('H' IN duration)-3)) AS INT) * 60 * 60 as dseconds from prdwa17_staging.videos where duration LIKE '%H%' and NOT duration LIKE '%M%' AND NOT duration LIKE '%S%') -- H /M /SUNION(select id, duration, CAST (substr(duration, 3, (POSITION('H' IN duration)-3)) AS INT) * 60 * 60 + CAST (substr(duration, POSITION('H' IN duration)+1, (POSITION('M' IN duration)-POSITION('H' IN duration))-1) AS INT) * 60as dseconds from prdwa17_staging.videos where duration LIKE '%H%M%' AND NOT duration LIKE '%S%') -- H%M /SUNION(select id, duration, CAST (substr(duration, 3, (POSITION('H' IN duration)-3)) AS INT) * 60 * 60 + CAST (substr(duration, POSITION('H' IN duration)+1, (POSITION('M' IN duration)-POSITION('H' IN duration))-1) AS INT) * 60 +CAST (substr(duration, POSITION('M' IN duration)+1, (POSITION('S' IN duration)-POSITION('M' IN duration))-1) AS INT) as dseconds from prdwa17_staging.videos where duration LIKE '%H%M%S%') -- H%M%SUNION(select id, duration, CAST (substr(duration, 3, (POSITION('M' IN duration)-3)) AS INT) * 60as dseconds from prdwa17_staging.videos where duration LIKE '%M%' AND NOT duration LIKE '%S%' and NOT duration LIKE '%H%') -- /H M /SUNION(select id, duration, CAST (substr(duration, 3, (POSITION('M' IN duration)-3)) AS INT) * 60 + CAST (substr(duration, POSITION('M' IN duration)+1, (POSITION('S' IN duration)-POSITION('M' IN duration))-1) AS INT) as dsecondsfrom prdwa17_staging.videos where duration LIKE '%M%S' and NOT duration LIKE '%H%') -- M%S /HUNION(select id, duration, CAST(substr(duration, 3, (POSITION('S' IN duration)-3)) AS INT) as dsecondsfrom prdwa17_staging.videos where duration LIKE '%S%' AND NOT duration LIKE '%M%' and NOT duration LIKE '%H%')) as s group by s.id;select count(distinct id) from prdwa17_staging.videos;