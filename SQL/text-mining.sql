DROP TABLE prdwa17_staging.ldamodel;
DROP TABLE prdwa17_staging.ldaout1;
SELECT * FROM LDATrainer (
ON (SELECT 1) PARTITION BY 1
InputTable ('prdwa17_staging.tf_idf_out')
ModelTable ('prdwa17_staging.ldamodel')
OutputTable ('prdwa17_staging.ldaout1')
DocIDColumn ('docid')
WordColumn ('term')
CountColumn ('tf_idf')
Eta(0.01)
TOPICNUMBER(9)
OUTPUTTOPICNUMBER(5)
OUTPUTTOPICWORDNUMBER(100)
);

select docid, topicid, topicweight from prdwa17_staging.ldaout1 order by 1, 3;
select distinct l.topicid, v.content from prdwa17_staging.ldaout1 l inner join 
prdwa17_staging.videos_titles_descriptions v on l.docid = v.id order by l.topicid;