CREATE TABLE prdwa17_staging.channels_backup distribute by hash(screenshot) as
select * from prdwa17_staging.channels;
CREATE TABLE prdwa17_staging.videos_backup distribute by hash(screenshot) as
select * from prdwa17_staging.videos;
CREATE TABLE prdwa17_staging.videoscomments_backup distribute by hash(screenshot) as
select * from prdwa17_staging.videoscomments;

select * from prdwa17_staging.videos_backup;

select * from prdwa17_staging.channels_backup;

select count(*) from prdwa17_staging.videoscomments_backup;
/*
insert into prdwa17_staging.channels
select * from prdwa17_staging.channels;
insert into prdwa17_staging.videos_backup
select * from prdwa17_staging.videos;
insert into prdwa17_staging.videoscomments_backup
select * from prdwa17_staging.videoscomments;*/