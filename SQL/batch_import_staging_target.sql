--les requêtes pour enlever 'https://en.wikipedia.org/wiki/' dans la colonne topiccategory
SELECT id, LTRIM(topiccategory_1,'https://en.wikipedia.org/wiki/') AS trimtopic1 
FROM prdwa17_staging.channels;

SELECT id, LTRIM(topiccategory_2,'https://en.wikipedia.org/wiki/') AS trimtopic2
FROM prdwa17_staging.channels;

SELECT id, LTRIM(topiccategory_3,'https://en.wikipedia.org/wiki/') AS trimtopic3
FROM prdwa17_staging.channels;

