--create table prdwa17_batch_load.videos_titles distribute by hash(id) AS
truncate prdwa17_batch_load.videos_titles;
insert into prdwa17_batch_load.videos_titles
select distinct id, title from prdwa17_batch_load.videos;

--create table prdwa17_batch_load.videos_descriptions distribute by hash(id) AS
truncate prdwa17_batch_load.videos_descriptions;
insert into prdwa17_batch_load.videos_descriptions
select distinct id, description from prdwa17_batch_load.videos;

create table prdwa17_batch_load.videos_titles_descriptions distribute by hash(id) AS
--insert into prdwa17_batch_load.videos_titles_descriptions
select distinct id, regexp_replace((title || ' ' || description), '(http.+?|www.+?) ', ' ')
as content from prdwa17_batch_load.videos;

create table prdwa17_batch_load.parsed_titles_descriptions DISTRIBUTE BY hash(docid) AS
--insert into prdwa17_batch_load.parsed_titles_descriptions
select id as docid, TRIM(token) as term, frequency as count from text_parser(on 
(select id, content from prdwa17_batch_load.videos_titles_descriptions)
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

--DROP TABLE prdwa17_batch_load.ldamodel;
--DROP TABLE prdwa17_batch_load.ldaout1;
SELECT * FROM LDATrainer (
ON (SELECT 1) PARTITION BY 1
InputTable ('prdwa17_batch_load.tf_idf_out')
ModelTable ('prdwa17_batch_load.ldamodel')
OutputTable ('prdwa17_batch_load.ldaout1')
DocIDColumn ('docid')
WordColumn ('term')
CountColumn ('tf_idf')
Eta(0.01)
TOPICNUMBER(9)
OUTPUTTOPICNUMBER(5)
OUTPUTTOPICWORDNUMBER(100)
);

select docid, topicid, topicweight from prdwa17_batch_load.ldaout1 order by 1, 3;
select distinct l.topicid, v.content from prdwa17_batch_load.ldaout1 l inner join 
prdwa17_batch_load.videos_titles_descriptions v on l.docid = v.id order by l.topicid;