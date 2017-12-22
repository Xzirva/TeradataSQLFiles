--select avg(s) from (select distinct id, avg(commentCount) as s from prdwa17_staging.videos 
--where fetchedat = (select fetchedat from prdwa17_staging.videos order by 1 desc limit 1) group by id) as t;

truncate prdwa17_staging.channels;
truncate prdwa17_staging.videos;

insert into prdwa17_staging.videos_clbu
select * from prdwa17_staging.videos;

insert into prdwa17_staging.channels_clbu
select * from prdwa17_staging.channels;

insert into prdwa17_staging.videoscomments_clbu
select * from prdwa17_staging.videoscomments;

select * from pivot(on
prdwa17_staging.tf_idf_out
partition by docid
order by term
partitions('docid')
rows(100)
metrics('tf_idf')
) order by docid;

select term, tf_idf from prdwa17_staging.tf_idf_out where docid = '-4xTzuLXTIU' order by term;

select docid, count(*) from prdwa17_staging.tf_idf_out group by docid;
select * from prdwa17_staging.videos where fetchedat = '2017-12-18 01:00:32.000000';
select distinct fetchedat from prdwa17_staging.channels
where fetchedat not in (
select distinct fetchedat from prdwa17_staging.videos);
select * from prdwa17_staging.videos order by fetchedat limit 10000;

select * from prdwa17_staging.videoscomments where videoid = 's3Cylg6TwnA';

-----------------------------------------------------------------------------------
select fetchedat, count(1) from prdwa17_staging.videos group by fetchedat order by fetchedat;
select fetchedat, count(1) from prdwa17_staging.videos group by fetchedat order by fetchedat;

