TRUNCATE prdwa17_staging.videos;
TRUNCATE prdwa17_staging.channels;
TRUNCATE prdwa17_staging.videosComments;

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
select id, description from prdwa17_staging.videos_test;

