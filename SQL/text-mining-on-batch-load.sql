--create table prdwa17_batch_load.videos_titles distribute by hash(id) AS
truncate prdwa17_batch_load.videos_titles;
insert into prdwa17_batch_load.videos_titles
select distinct id, title from prdwa17_batch_load.videos;

--create table prdwa17_batch_load.videos_descriptions distribute by hash(id) AS
truncate prdwa17_batch_load.videos_descriptions;
insert into prdwa17_batch_load.videos_descriptions
select distinct id, description from prdwa17_batch_load.videos;

drop table prdwa17_batch_load.videos_titles_descriptions;
create table prdwa17_batch_load.videos_titles_descriptions distribute by hash(id) AS
--insert into prdwa17_batch_load.videos_titles_descriptions
select distinct id, regexp_replace((title || ' ' || description), '(http.+?|www.+?)(\s|\t|\n)', ' ')
as content from prdwa17_batch_load.videos;

select * from prdwa17_batch_load.videos_titles_descriptions where id = '28h5Vz7NuVw';
update prdwa17_batch_load.videos_titles_descriptions 
set content = regexp_replace(content, '(http.|www.)', ' ');

select id, content from prdwa17_batch_load.videos_titles_descriptions where content like '%http%';
--select id, regexp_replace(content, '(http.+?|www.+?)(\s|\t|\n)', ' ') from prdwa17_batch_load.videos_titles_descriptions;

drop table prdwa17_batch_load.parsed_titles_descriptions;
create table prdwa17_batch_load.parsed_titles_descriptions DISTRIBUTE BY hash(docid) AS
--insert into prdwa17_batch_load.parsed_titles_descriptions
select id as docid, TRIM(token) as term, frequency as count from text_parser(on 
(select id, content from prdwa17_batch_load.videos_titles_descriptions)
	text_column('content')
	case_insensitive('true')
	stemming('true')
	Punctuation ('\[[]\]\_\*\".,?:;!\|\%\&\#\+\-\=\$\@\(\)’”“”\'–\]')	
	list_positions('false')
	remove_stop_words('true')
	accumulate('id', 'content')
	)
order by term;
--'

delete from prdwa17_batch_load.parsed_titles_descriptions where term like '' OR term like '% %';

DROP TABLE prdwa17_batch_load.videos_titles_descriptions_sample;
create table prdwa17_batch_load.videos_titles_descriptions_sample distribute by hash(id) as
select * from prdwa17_batch_load.videos_titles_descriptions limit 1000;


DROP TABLE prdwa17_batch_load.parsed_titles_descriptions_sample;
create table prdwa17_batch_load.parsed_titles_descriptions_sample distribute by hash(docid) as
--insert into prdwa17_batch_load.parsed_titles_descriptions
select id as docid, TRIM(token) as term, frequency as count from text_parser(on 
(select id, content from prdwa17_batch_load.videos_titles_descriptions_sample)
	text_column('content')
	case_insensitive('true')
	stemming('true')
	Punctuation ('\[[]\]\_\*\".,?:;!\|\%\&\#\+\-\=\$\@\(\)’”“”\'–\]')	
	list_positions('false')
	remove_stop_words('true')
	accumulate('id', 'content')
	)
order by term;
--'

delete from prdwa17_batch_load.parsed_titles_descriptions_sample where term like '' OR term like '% %';

delete from prdwa17_batch_load.parsed_titles_descriptions_sample 
where term in (select LOWER(title) from prdwa17_backup.unique_channels);


--select id, regexp_replace(content, uc.channel, ' ') 
--from prdwa17_batch_load.videos v
--inner join prdwa17_backup.unique_channels uc on v.channelid = uc.id;

--select v.id, (v.description || ' ' || v.title) as content, uc.title
--from prdwa17_batch_load.videos v
--inner join prdwa17_backup.unique_channels uc on v.channelid = uc.id and (v.description || ' ' || v.title) LIKE '%' || uc.title ||'%';

DROP TABLE prdwa17_batch_load.tf_idf_out_sample;

select distinct docid from prdwa17_batch_load.tf_idf_out_sample; 

drop table prdwa17_batch_load.LDATries;
create table prdwa17_batch_load.LDATries (
number int,
paramEta decimal,
paramAlpha decimal,
paramTopicNumber int,
paramOutputTopicNumber int,
paramOUTPUTTOPICWORDNUMBER int,
message TEXT
)distribute by hash(number);

DROP TABLE prdwa17_batch_load.ldamodel;
DROP TABLE prdwa17_batch_load.ldaout1;
insert into prdwa17_batch_load.LDATries
SELECT (select max(number) + 1 from prdwa17_batch_load.LDATries),
0.001 as pEta, 
0.001 pAlpha, 
100 as pTopicNumber, 
3 pOutputTopicNumber, 
100 pOutputTopicWordNumber,
ldaT.message
FROM LDATrainer (
ON (SELECT 1) PARTITION BY 1
InputTable ('prdwa17_batch_load.tf_idf_out_sample')
ModelTable ('prdwa17_batch_load.ldamodel')
OutputTable ('prdwa17_batch_load.ldaout1')
DocIDColumn ('docid')
WordColumn ('term')
CountColumn ('tf_idf')
Eta(0.001)
Alpha(0.001)
TOPICNUMBER(10)
OUTPUTTOPICNUMBER(3)
OUTPUTTOPICWORDNUMBER(15)
) as ldaT;

select number, message from prdwa17_batch_load.LDATries;


select distinct topicid, topicwords from prdwa17_batch_load.ldaout1;
select term, tf_idf from prdwa17_batch_load.tf_idf_out_sample where tf_idf < 0.01 order by term;
select docid, topicid, topicweight from prdwa17_batch_load.ldaout1 order by 1, 3;
select distinct l.topicid, v.content from prdwa17_batch_load.ldaout1 l inner join 
prdwa17_batch_load.videos_titles_descriptions v on l.docid = v.id order by l.topicid;