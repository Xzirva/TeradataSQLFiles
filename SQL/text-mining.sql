create table prdwa17_staging.videos_seven_years distribute by hash(channelid) as
select * from prdwa17_staging.videos;
create table prdwa17_staging.videos_seven_years_backup distribute by hash(channelid) as
select * from prdwa17_staging.videos;
-- SELECT * FROM prdwa17_staging.vidoescomments;
-- select extract('hour' from fetchedat) from prdwa17_staging.videosComments;

create table prdwa17_staging.videos_titles (
	id varchar(100),
	title varchar(255)
)DISTRIBUTE BY hash(id);

truncate prdwa17_staging.videos_titles;
insert into prdwa17_staging.videos_titles
select id, title from prdwa17_staging.videos_sybu;

truncate prdwa17_staging.videos_descriptions;
insert into prdwa17_staging.videos_descriptions
select id, description from prdwa17_staging.videos_sybu;

create table prdwa17_staging.videos_descriptions (
	id varchar(100),
	description TEXT
)DISTRIBUTE BY hash(id);
select count(*) from prdwa17_staging.videos_seven_years_backup;

-- Cleaning description: Removing urls
update prdwa17_staging.videos_descriptions
set description = regexp_replace(description, '(http.+?|www.+?) ', ' ');

-- Cleaning title: Removing urls
update prdwa17_staging.videos_titles 
set title = regexp_replace(title, '(http.+?|www.+?) ', ' ');

-- Parsing Title/descriptions
--create table prdwa17_staging.videos_parsed_titles distribute by hash(id) as
drop table prdwa17_staging.tmp;
create table prdwa17_staging.tmp distribute by hash(id) as 
select id, description, TRIM(token) as term, length(TRIM(token)) ,frequency, position from text_parser(on 
(select * from prdwa17_staging.videos_descriptions)
	text_column('description')
	case_insensitive('true')
	stemming('true')
	Punctuation ('\[\]\".,?:;!\|\%\&\#\+\-\=\$\@\(\)\`\'\]')	
	list_positions('false')
	remove_stop_words('true')
	accumulate('id', 'description')
	)
order by term;

--' -- BS!!!!


-- text_tagging
-- q-gram
-- Teradata community Guru decouper les mots en lettres (distances)
-- 
create table prdwa17_staging.unwanted_chars(
	title VARCHAR(1) primary key
);
-- Notes call
-- 
select * from prdwa17_staging.tmp;
select res.id, res.vsytitle, res.uctitle, ' ' as title from (
select vsy.id, vsy.title as vsytitle, uc.title as uctitle from prdwa17_staging.videos_seven_years as vsy
inner join prdwa17_staging.unwanted_chars as uc 
on vsy.title LIKE '%' || uc.title || '%')
as res where res.uctitle != ''
;
insert into prdwa17_staging.unwanted_chars(title) values
('&'),('#'),('$'),('+'),('-'),('='),('@'),('('),(')'),('~');
insert into prdwa17_staging.unwanted_chars(title) values
('['),(']'),('"'),(':'),('.'),(';'),('!'),(','),('|');

insert into prdwa17_staging.unwanted_chars(title) values
('?'),('%');

--truncate prdwa17_staging.unwanted_chars;
--insert into prdwa17_staging.unwanted_chars
--select regexp_replace(regexp_replace(term ,'wars', ''), 'them', '') from prdwa17_staging.tmp where id = '03hZMc6toQ8' ORDER BY 1 DESC LIMIT 1;

SELECT * FROM ID(
       on channels
);

select term, length(term) from prdwa17_staging.tmp where term like '%\'%';
--\[ ' �
-- there
select * from prdwa17_staging.unwanted_chars;
truncate prdwa17_staging.unwanted_chars;
insert into prdwa17_staging.unwanted_chars
select distinct term from prdwa17_staging.parsed_titles order by term limit 2;

select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1;
select * from prdwa17_staging.videos_seven_years_backup;
select distinct term, sum(frequency) from prdwa17_staging.tmp group by term;
select * from prdwa17_staging.tmp;
-- Parser postprocessing
select term, length(term) from prdwa17_staging.tmp 
where token like '%\=%' OR token like '%\+%' OR token like '%\&%' OR token like '%\-%'
OR token like '%\=%';
/*select distinct replace(pt.term, uc.title, '') as new_term
from prdwa17_staging.parsed_titles pt, prdwa17_staging.unwanted_chars uc
where pt.term LIKE uc.title || '%' or pt.term LIKE '%' || uc.title;*/

update prdwa17_staging.videos_descriptions set description = regexp_replace(description, (select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1), '')
where description LIKE '%' || (select * from prdwa17_staging.unwanted_chars order by 1 desc limit 1) || '%';