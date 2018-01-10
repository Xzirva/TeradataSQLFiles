truncate prdwa17_backup.videos;
truncate prdwa17_backup.channels;
truncate prdwa17_backup.videoscomments;

insert into prdwa17_backup.channels
select * from prdwa17_staging.channels;

insert into prdwa17_backup.videos
select * from prdwa17_staging.videos;

insert into prdwa17_backup.videoscomments
select * from prdwa17_staging.videoscomments;