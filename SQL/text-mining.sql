create table prdwa17_staging.videos_seven_years distribute by hash(channelid) as
select * from prdwa17_staging.videos;
create table prdwa17_staging.videos_seven_years_backup distribute by hash(channelid) as
select * from prdwa17_staging.videos;
-- SELECT * FROM prdwa17_staging.vidoescomments;
-- select extract('hour' from fetchedat) from prdwa17_staging.videosComments;
select count(*) from prdwa17_staging.videos_seven_years_backup;

-- Cleaning description: Removing urls
update prdwa17_staging.videos_seven_years 
set description = regexp_replace(description, '(http.+?|www.+?) ', ' ');

-- Cleaning title: Removing urls
update prdwa17_staging.videos_seven_years 
set title = regexp_replace(title, '(http.+?|www.+?) ', ' ');

-- Parsing Title
--create table prdwa17_staging.videos_parsed_titles distribute by hash(id) as
drop table prdwa17_staging.tmp;
create table prdwa17_staging.parsed_titles distribute by hash(id) as 
select id, title, TRIM(token) as term, length(TRIM(token)) ,frequency, position from text_parser(on 
(select * from prdwa17_staging.videos_seven_years)
	text_column('title')
	case_insensitive('true')
	stemming('true')
	Punctuation ('\[\]\".,?:;!\|\%\&\#\+\-\=\$\@\(\)\]')	
	list_positions('false')
	remove_stop_words('true')
	accumulate('id', 'title')
	)
order by term;
-- text_tagging
-- q-gram
-- Teradata community Guru decouper les mots en lettres (distances)
-- 
create table prdwa17_staging.unwanted_chars(
	title VARCHAR(1) primary key
);
-- Notes call
-- 
select res.id, res.vsytitle, res.uctitle, ' ' as title from (
select vsy.id, vsy.title as vsytitle, uc.title as uctitle from prdwa17_staging.videos_seven_years as vsy
inner join prdwa17_staging.unwanted_chars as uc 
on vsy.title LIKE '%' || uc.title || '%')
as res where res.uctitle != ''
;
insert into prdwa17_staging.unwanted_chars(title) values
('&'),('#'),('$'),('+'),('-'),('='),('@'),('('),(')'),('~');
insert into prdwa17_staging.unwanted_chars(title) values
('['),(']'),('"'),(''),(':'),('.'),(';'),('!'),(','),('|');

insert into prdwa17_staging.unwanted_chars(title) values
('?'),('%');
--\[ ' �
-- there
select distinct term from prdwa17_staging.parsed_titles order by term limit 6;
select * from prdwa17_staging.videos_seven_years_backup;
select distinct term, sum(frequency) from prdwa17_staging.tmp group by term;
select * from prdwa17_staging.tmp;
-- Parser postprocessing
select term, length(term) from prdwa17_staging.tmp 
where token like '%\=%' OR token like '%\+%' OR token like '%\&%' OR token like '%\-%'
OR token like '%\=%';

select * from prdwa17_staging.videos;