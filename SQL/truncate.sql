TRUNCATE prdwa17_backup.videos;
TRUNCATE prdwa17_backup.channels;
TRUNCATE prdwa17_backup.videosComments;

TRUNCATE prdwa17_staging.videos_test;
TRUNCATE prdwa17_staging.channels_test;
TRUNCATE prdwa17_staging.videosComments_test;

TRUNCATE prdwa17_staging.videos_sybu;
TRUNCATE prdwa17_staging.channels_sybu;
TRUNCATE prdwa17_staging.videosComments_sybu;

truncate prdwa17_staging.videos_descriptions;
select id, count(id) from prdwa17_staging.videosComments_test where videoid = '8aItBcYDNZs' group by id;
select * from prdwa17_staging.videosComments_test where id = 'UgzcyDFkjuHDhn-R_np4AaABAg';
insert into prdwa17_staging.videos_descriptions
select id, description from prdwa17_staging.video;

--select fetchedat from prdwa17_staging.videos order by 1 desc;

--create table prdwa17_backup.wrongdataonvideos distribute by hash(id) as
select channelid, id, title, description, publishedat, count from (
select *, row_number() over (partition by channelid, id order by count desc) as rank from prdwa17_backup.videos_ordered
) as s where rank = 1;
drop table prdwa17_backup.videos_ordered;
create table prdwa17_backup.videos_ordered distribute by hash(id) as
select channelid, id, title, description, publishedat, count(1) as count from prdwa17_backup.videos group by channelid, id, title, description, publishedat having count(1) > 1 order by 1, 2, 3, 6 desc;
select channelid, id, count(1) from prdwa17_backup.videos_ordered group by channelid, id;
select * from prdwa17_backup.videos_ordered where id='CDoJRFADpqs' and channelid = 'UCBi2mrWuNuyYy4gbM6fU18Q';
--count(1) < 20 and