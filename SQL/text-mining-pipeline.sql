truncate prdwa17_staging.videos_titles;
insert into prdwa17_staging.videos_titles
select id, title from prdwa17_staging.videos;

truncate prdwa17_staging.videos_descriptions;
insert into prdwa17_staging.videos_descriptions
select id, description from prdwa17_staging.videos;

insert into prdwa17_staging.videos_titles_descriptions
select distinct id, regexp_replace((title || ' ' || description), '(http.+?|www.+?) ', ' ')
as content from prdwa17_staging.videos_test;

/*select id, description --regexp_replace(description, uc.title, '') 
from prdwa17_staging.videos_descriptions, 
(select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1) uc
--(select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1), '')
where description LIKE '%' || uc.title || '%';

update prdwa17_staging.videos_descriptions set description = regexp_replace(description,
(select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1), ' ') where
description like '%' || (select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1) || '%';

update prdwa17_staging.videos_descriptions set description = regexp_replace(description,
(select * from prdwa17_staging.unwanted_chars order by 1 asc limit 1), ' ') where
description like '%' || (select * from prdwa17_staging.unwanted_chars order by 1 asc limit 1) || '%';
update prdwa17_staging.videos_titles set title = regexp_replace(title, 
(select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1), '')
where title LIKE '%' || (select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1) || '%';
*/
--truncate prdwa17_staging.parsed_descriptions;
--create table prdwa17_staging.parsed_descriptions DISTRIBUTE BY hash(id) AS

--drop table prdwa17_staging.parsed_titles_descriptions;
truncate prdwa17_staging.parsed_titles_description;
insert into prdwa17_staging.parsed_titles_descriptions
select id as docid, TRIM(token) as term, frequency as count from text_parser(on 
(select id, content from prdwa17_staging.videos_titles_descriptions)
	text_column('content')
	case_insensitive('true')
	stemming('true')
	Punctuation ('\[\]\".,?:;!\|\%\&\#\+\-\=\$\@\(\)’”“”\'–\]')	
	list_positions('false')
	remove_stop_words('true')
	accumulate('id', 'content')
	)
order by term;
--'
	
-- OK
delete from prdwa17_staging.parsed_titles_descriptions where term like '' OR term like '% %';

create table prdwa17_staging.tf_idf_out DISTRIBUTE BY HASH(docid) AS
select * from tf_idf (
ON tf ( ON  prdwa17_staging.parsed_titles_descriptions) as tf PARTITION BY term
ON (select count(distinct docid) from prdwa17_staging.parsed_titles_descriptions
) AS doccount DIMENSION
);

--select id, ROW_NUMBER() OVER ( partition by id order by id) as row_number from prdwa17_staging.videos;