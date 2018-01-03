CREATE SCHEMA prdwa17_clean;

-- clean the data

create table prdwa17_clean.videocommentpropre distribute by hash(CODE_VIDEOCOMMENT) AS
select CODE_VIDEO, CODE_VIDEOCOMMENT, regexp_replace(T_TEXT_ORIGINAL, '(http.+?|www.+?) ', ' ')
as videocomment_content from prdwa17_target.T_VIDEOCOMMENT;


-- use dictionary to extract the sentiment
create table prdwa17_ml.videocomment_sentiment_extract_dictionary
DISTRIBUTE BY HASH(CODE_VIDEOCOMMENT) AS
SELECT * FROM ExtractSentiment
(
	on prdwa17_clean.videocommentpropre
	TEXT_COLUMN ('videocomment_content')
	--language : mostly english, value default
	MODEL ('dictionary')
	LEVEL ('document')
	ACCUMULATE('CODE_VIDEO','CODE_VIDEOCOMMENT','videocomment_content')
	HIGH_PRIORITY('NEGATIVE_RECALL')

	
);


--number of positive commentaries and negative commentaries for each video
create table prdwa17_ml.positive_comment distribute by hash(CODE_VIDEOCOMMENT) AS
select CODE_VIDEO, CODE_VIDEOCOMMENT, OUT_POLARITY
from prdwa17_ml.videocomment_sentiment_extract_dictionary
where OUT_POLARITY = 'POS';

create table prdwa17_ml.nbpositive_comment distribute by hash(CODE_VIDEO) AS
select CODE_VIDEO, count(*) as number_positive_per_video
from prdwa17_ml.positive_comment
group by (CODE_VIDEO);


create table prdwa17_ml.negative_comment distribute by hash(CODE_VIDEOCOMMENT) AS
select CODE_VIDEO, CODE_VIDEOCOMMENT, OUT_POLARITY
from prdwa17_ml.videocomment_sentiment_extract_dictionary
where OUT_POLARITY = 'NEG';

create table prdwa17_ml.nbnegative_comment distribute by hash(CODE_VIDEO) AS
select CODE_VIDEO, count(*) as number_negative_per_video
from prdwa17_ml.negative_comment
group by (CODE_VIDEO);

--mean of nb like-count for each video
create table prdwa17_ml.likecount distribute by hash(CODE_VIDEO) AS
select CODE_VIDEO, avg(t_likecount) as number_like_count_per_video
from prdwa17_target.t_videofacts
group by (CODE_VIDEO);

--mean of nb dislike-count for each video
create table prdwa17_ml.dislikecount distribute by hash(CODE_VIDEO) AS
select CODE_VIDEO, avg(t_dislikecount) as number_dislike_count_per_video
from prdwa17_target.t_videofacts
group by (CODE_VIDEO);

--mean of nb favorite-count for each video
create table prdwa17_ml.favoritecount distribute by hash(CODE_VIDEO) AS
select CODE_VIDEO, avg(t_favoritecount) as number_favorite_count_per_video
from prdwa17_target.t_videofacts
group by (CODE_VIDEO);

--plot
CREATE SCHEMA prdwa17_plot;



create table prdwa17_plot.nbpositive_likecount distribute by hash(CODE_VIDEO) AS
Select a.code_video, a.number_positive_per_video, b.number_like_count_per_video
from  prdwa17_ml.nbpositive_comment as a
inner join prdwa17_ml.likecount as b
on a.code_video = b.code_video;

create table prdwa17_plot.nbpositive_favoritecount distribute by hash(CODE_VIDEO) AS
Select a.code_video, a.number_positive_per_video, b.number_favorite_count_per_video
from  prdwa17_ml.nbpositive_comment as a
inner join prdwa17_ml.favoritecount as b
on a.code_video = b.code_video;

create table prdwa17_plot.nbpositive_dislikecount distribute by hash(CODE_VIDEO) AS
Select a.code_video, a.number_positive_per_video, b.number_dislike_count_per_video
from  prdwa17_ml.nbpositive_comment as a
inner join prdwa17_ml.dislikecount as b
on a.code_video = b.code_video;



create table prdwa17_plot.nbnegative_likecount distribute by hash(CODE_VIDEO) AS
Select a.code_video, a.number_negative_per_video, b.number_like_count_per_video
from  prdwa17_ml.nbnegative_comment as a
inner join prdwa17_ml.likecount as b
on a.code_video = b.code_video;

create table prdwa17_plot.nbnegative_favoritecount distribute by hash(CODE_VIDEO) AS
Select a.code_video, a.number_negative_per_video, b.number_favorite_count_per_video
from  prdwa17_ml.nbnegative_comment as a
inner join prdwa17_ml.favoritecount as b
on a.code_video = b.code_video;

create table prdwa17_plot.nbnegative_dislikecount distribute by hash(CODE_VIDEO) AS
Select a.code_video, a.number_negative_per_video, b.number_dislike_count_per_video
from  prdwa17_ml.nbnegative_comment as a
inner join prdwa17_ml.dislikecount as b
on a.code_video = b.code_video;
