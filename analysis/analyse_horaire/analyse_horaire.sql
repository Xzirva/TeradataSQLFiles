create table prdwa17_ml.max_nbview distribute by hash(CODE_VIDEO) AS
select CODE_VIDEO,
max(T_VIEWCOUNT) as MAXVIEW,
avg(T_CHANNELSUBSCRIBERCOUNT) as CHANNELSUBSCRIBERCOUNT,
avg(T_CHANNELVIDEOCOUNT) as CHANNELVIDEOCOUNT,
avg(T_COMMENTCOUNT) as COMMENTCOUNT,
avg(T_LIKECOUNT) as LIKECOUNT,
avg(T_DISLIKECOUNT) as DISLIKECOUNT
from prdwa17_target.T_VIDEOFACTS
group by CODE_VIDEO;



create table prdwa17_ml.max_nbview_mintime distribute by hash(CODE_VIDEO) AS
select a.code_video, a.maxview, a.CHANNELSUBSCRIBERCOUNT, a.CHANNELVIDEOCOUNT, a.COMMENTCOUNT, a.LIKECOUNT, a.DISLIKECOUNT,
b.T_ACTUALDATE
from prdwa17_ml.max_nbview as a, prdwa17_target.T_VIDEOFACTS as b
where a.code_video = b.code_video
and a.maxview = b.T_VIEWCOUNT;




create table prdwa17_ml.max_nbview_mintime_inference distribute by hash(CODE_VIDEO) AS
select code_video,
max(maxview) as maxview, 
max(CHANNELSUBSCRIBERCOUNT) as CHANNELSUBSCRIBERCOUNT,
max(CHANNELVIDEOCOUNT) as CHANNELVIDEOCOUNT, 
max(COMMENTCOUNT) as COMMENTCOUNT, 
max(LIKECOUNT) as LIKECOUNT, 
max(DISLIKECOUNT) as DISLIKECOUNT,
min(T_ACTUALDATE) as mintimewithmaxview
from prdwa17_ml.max_nbview_mintime
group by CODE_VIDEO;


create table prdwa17_ml.max_nbview_minhour_inference distribute by hash(CODE_VIDEO) AS
select 
a.code_video,
a.maxview,
a.CHANNELSUBSCRIBERCOUNT,
a.CHANNELVIDEOCOUNT,
a.COMMENTCOUNT,
a.LIKECOUNT,
a.DISLIKECOUNT,
a.mintimewithmaxview,
b.T_YEAR as year,
b.T_MONTH as month,
b.T_DAY as day,
b.T_HOUR as hour,
b.T_MINUTES as minutes,
b.T_SECONDS as seconds
from prdwa17_ml.max_nbview_mintime_inference as a
inner join prdwa17_target.T_TIME as b
on 	a.mintimewithmaxview = b.T_ACTUALDATE;


