CREATE SCHEMA prdwa17_clean;


create table prdwa17_clean.videocommentpropre distribute by hash(CODE_VIDEOCOMMENT) AS
select CODE_VIDEOCOMMENT, regexp_replace(T_TEXT_ORIGINAL, '(http.+?|www.+?) ', ' ')
as videocomment_content from prdwa17_target.T_VIDEOCOMMENT;



create table prdwa17_ml.videocomment_sentiment_extract_dictionary
DISTRIBUTE BY HASH(CODE_VIDEOCOMMENT) AS
SELECT * FROM ExtractSentiment
(
	on prdwa17_clean.videocommentpropre
	TEXT_COLUMN ('videocomment_content')
	MODEL ('dictionary')
	LEVEL ('document')
	ACCUMULATE('CODE_VIDEOCOMMENT','videocomment_content')
	
);


--to do

--1/clean the data
--2/change the parameters to make the resultat better (video Youtube and documentation)
--3/hashtag# important, find a way to attribute importance





