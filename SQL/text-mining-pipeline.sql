-- Cleaning description: Removing urls
update prdwa17_staging.videos_descriptions
set description = regexp_replace(description, '(http.+?|www.+?) ', ' ');
-- 

select id, description --regexp_replace(description, uc.title, '') 
from prdwa17_staging.videos_descriptions, 
(select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1) uc
--(select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1), '')
where description LIKE '%' || uc.title || '%';

update prdwa17_staging.videos_descriptions set description = regexp_replace(description,
(select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1), '') where
description like '%' || (select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1) || '%';

update prdwa17_staging.videos_descriptions set description = regexp_replace(description,
(select * from prdwa17_staging.unwanted_chars order by 1 asc limit 1), '') where
description like '%' || (select * from prdwa17_staging.unwanted_chars order by 1 asc limit 1) || '%';
-- Cleaning title: Removing urls
update prdwa17_staging.videos_titles
set title = regexp_replace(title, '(http.+?|www.+?) ', ' ');
update prdwa17_staging.videos_titles set title = regexp_replace(title, (select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1), '')
where title LIKE '%' || (select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1) || '%';

select * from prdwa17_staging.
--truncate prdwa17_staging.parsed_descriptions;
create table prdwa17_staging.parsed_descriptions DISTRIBUTE BY hash(id) AS
select id, description, TRIM(token) as term, length(TRIM(token)) ,frequency, position from text_parser(on 
(select * from prdwa17_staging.videos_descriptions)
	text_column('description')
	case_insensitive('true')
	stemming('true')
	Punctuation ('\[\]\".,?:;!\|\%\&\#\+\-\=\$\@\(\)\'\]')	
	list_positions('false')
	remove_stop_words('true')
	accumulate('id', 'description')
	)
order by term;
--'
	
--truncate prdwa17_staging.parsed_titles;
create table prdwa17_staging.parsed_titles DISTRIBUTE BY hash(id) AS
select id, title, TRIM(token) as term, length(TRIM(token)) ,frequency, position from text_parser(on 
(select * from prdwa17_staging.videos_titles)
	text_column('title')
	case_insensitive('true')
	stemming('true')
	Punctuation ('\[\]\".,?:;!\|\%\&\#\+\-\=\$\@\(\)\'\]')	
	list_positions('false')
	remove_stop_words('true')
	accumulate('id', 'title')
	)
order by term;
--'
insert into prdwa17_staging.unwanted_chars
select regexp_replace(term, 'trump', '') from 
(select term, sum(frequency) from prdwa17_staging.parsed_titles group by term) s 
where term like 'trump_';

delete from prdwa17_staging.parsed_titles where term like '';
select * from prdwa17_staging.parsed_descriptions where term like '';
create table prdwa17_staging.tf_idf_in_descriptions DISTRIBUTE BY HASH(term) as
select id as videoid, term from prdwa17_staging.parsed_descriptions;

create table prdwa17_staging.tf_idf_out_descriptions DISTRIBUTE BY HASH(videoid) AS
select * from tf_idf
(
ON tf
(
ON (select * from prdwa17_staging.tf_idf_in_descriptions PARTITION by videoid)
) tf PARTITION BY term
ON (select count(distinct(videoid)) from prdwa17_staging.tf_idf_in_descriptions) videoscount DIMENSION
) order by videoid;