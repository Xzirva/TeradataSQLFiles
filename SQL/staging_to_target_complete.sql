-- create table prdwa17_backup.unique_channels distribute by hash(id) as
-- select s.id, s.title, s.description from
-- (select distinct id, title, description, row_number() over (partition by id order by id desc) as rank from prdwa17_backup.channels) as s where rank = 1;

INSERT INTO "prdwa17_target"."t_video" 
 ("code_video", 
 "t_title", 
 "t_videoid", 
 "t_description", 
 "t_publishedat",
 "t_channelid", 
 "t_channeltitle", 
 "t_channeldescription", 
 "t_topiccategorie1", 
 "t_topiccategorie2", 
 "t_topiccategorie3")
SELECT v.code_video,
 v.title,
 v.id,
 v.description,
 v.publishedat,
 v.channelid,
 v.channeltitle,
 v.channeldescription,
 v.t1,
 v.t2,
 v.t3
 from (
 SELECT DISTINCT vo."id" || '-' || vo."channelid"  as code_video,
 vo."title",
 vo."id", 
 vo."description",
 vo."publishedat", 
 "prdwa17_backup"."unique_channels"."id" as channelid, 
 "prdwa17_backup"."unique_channels"."title" as channeltitle,
 "prdwa17_backup"."unique_channels"."description" as channeldescription,
 'to-be-filled' as t1,
 'to-be-filled' as t2,
 'to-be-filled' as t3
 FROM 
(select channelid, id, title, description, publishedat, count from (
select *, row_number() over (partition by channelid, id order by count desc) as rank from prdwa17_backup.videos_ordered
) as s where rank = 1) as vo
 INNER JOIN "prdwa17_backup"."unique_channels"
 on "prdwa17_backup"."unique_channels"."id" = vo."channelid") as v;
 --where v.id not in (select code_video from "prdwa17_target"."t_video");
 
 /*VERSION RAPIDE POUR LES VIDEOS SANS LES CATEGORIES*/
 
 /*
 INSERT INTO "prdwa17_target"."t_video" 
 ("code_video", 
 "t_title", 
 "t_videoid", 
 "t_description", 
 "t_publishedat",
 "t_channelid", 
 "t_channeltitle", 
 "t_channeldescription")
 SELECT v.code_video,
 v.title,
 v.id,
 v.description,
 v.publishedat,
 v.channelid,
 v.channeltitle,
 v.channeldescription
 from (SELECT DISTINCT "prdwa17_backup"."videos"."id" as code_video,
 "prdwa17_backup"."videos"."title",
 "prdwa17_backup"."videos"."id", 
 "prdwa17_backup"."videos"."description",
 "prdwa17_backup"."videos"."publishedat", 
 "prdwa17_backup"."channels"."id" as channelid, 
 "prdwa17_backup"."channels"."title" as channeltitle,
 "prdwa17_backup"."channels"."description" as channeldescription
 FROM "prdwa17_backup"."videos"
 INNER JOIN "prdwa17_backup"."channels"
 on "prdwa17_backup"."channels"."id" = "prdwa17_backup"."videos"."channelid") as v
 where v.id not in (select code_video from "prdwa17_target"."t_video");

 */
 
 --INSERTION DANS LA TABLE TIME
 
 INSERT INTO "prdwa17_target"."t_time" 
("t_actualdate", 
"t_year", 
"t_month",
"t_week", 
"t_day", 
"t_hour", 
"t_minutes", 
"t_seconds", 
"t_trimester", 
"t_season")
SELECT DISTINCT "prdwa17_backup"."videos".fetchedat,
 extract('year' FROM "prdwa17_backup"."videos"."fetchedat"),
 extract('month' FROM "prdwa17_backup"."videos"."fetchedat"),
 extract('week' FROM "prdwa17_backup"."videos"."fetchedat"),
 extract('day' FROM "prdwa17_backup"."videos"."fetchedat"),
 extract('hour' FROM "prdwa17_backup"."videos"."fetchedat"),
 extract('minutes' FROM "prdwa17_backup"."videos"."fetchedat"),
 extract('seconds' FROM "prdwa17_backup"."videos"."fetchedat"),
 4,
 4
 FROM "prdwa17_backup"."videos"
 WHERE "prdwa17_backup"."videos".fetchedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
 INSERT INTO "prdwa17_target"."t_time" 
("t_actualdate", 
"t_year", 
"t_month",
"t_week", 
"t_day", 
"t_hour", 
"t_minutes", 
"t_seconds", 
"t_trimester", 
"t_season")
SELECT DISTINCT "prdwa17_backup"."videoscomments".fetchedat,
 extract('year' FROM "prdwa17_backup"."videoscomments"."fetchedat"),
 extract('month' FROM "prdwa17_backup"."videoscomments"."fetchedat"),
 extract('week' FROM "prdwa17_backup"."videoscomments"."fetchedat"),
 extract('day' FROM "prdwa17_backup"."videoscomments"."fetchedat"),
 extract('hour' FROM "prdwa17_backup"."videoscomments"."fetchedat"),
 extract('minutes' FROM "prdwa17_backup"."videoscomments"."fetchedat"),
 extract('seconds' FROM "prdwa17_backup"."videoscomments"."fetchedat"),
 4,
 4
 FROM "prdwa17_backup"."videoscomments"
 WHERE "prdwa17_backup"."videoscomments".fetchedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
 INSERT INTO "prdwa17_target"."t_time" 
("t_actualdate", 
"t_year", 
"t_month",
"t_week", 
"t_day", 
"t_hour", 
"t_minutes", 
"t_seconds", 
"t_trimester", 
"t_season")
SELECT DISTINCT "prdwa17_backup"."videos".publishedat,
 extract('year' FROM "prdwa17_backup"."videos"."publishedat"),
 extract('month' FROM "prdwa17_backup"."videos"."publishedat"),
 extract('week' FROM "prdwa17_backup"."videos"."publishedat"),
 extract('day' FROM "prdwa17_backup"."videos"."publishedat"),
 extract('hour' FROM "prdwa17_backup"."videos"."publishedat"),
 extract('minutes' FROM "prdwa17_backup"."videos"."publishedat"),
 extract('seconds' FROM "prdwa17_backup"."videos"."publishedat"),
 4,
 4
 FROM "prdwa17_backup"."videos"
 WHERE "prdwa17_backup"."videos".publishedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
 INSERT INTO "prdwa17_target"."t_time" 
("t_actualdate", 
"t_year", 
"t_month",
"t_week", 
"t_day", 
"t_hour", 
"t_minutes", 
"t_seconds", 
"t_trimester", 
"t_season")
SELECT DISTINCT "prdwa17_backup"."videoscomments".publishedat,
 extract('year' FROM "prdwa17_backup"."videoscomments"."publishedat"),
 extract('month' FROM "prdwa17_backup"."videoscomments"."publishedat"),
 extract('week' FROM "prdwa17_backup"."videoscomments"."publishedat"),
 extract('day' FROM "prdwa17_backup"."videoscomments"."publishedat"),
 extract('hour' FROM "prdwa17_backup"."videoscomments"."publishedat"),
 extract('minutes' FROM "prdwa17_backup"."videoscomments"."publishedat"),
 extract('seconds' FROM "prdwa17_backup"."videoscomments"."publishedat"),
 4,
 4
 FROM "prdwa17_backup"."videoscomments"
 WHERE "prdwa17_backup"."videoscomments".publishedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
 /* initialisation des faits à 0
  * nécessite selection du premier fetchedat pour initialiser les valeurs des compteurs pour la chaine
  */
 
 /*
INSERT INTO "prdwa17_target"."t_videofacts" 
("code_videofact",
"code_video", 
"t_actualdate", 
"t_channelcommentscount",
"t_channelsubscribercount", 
"t_channelvideocount", 
"t_commentcount", 
"t_likecount", 
"t_dislikecount", 
"t_viewcount", 
"t_favoritecount")
SELECT DISTINCT "prdwa17_backup"."videos".id,
"prdwa17_backup"."videos".id,
 "prdwa17_backup"."videos"."publishedat",
 "prdwa17_backup"."channels"."commentcount",
 "prdwa17_backup"."channels"."subscribercount",
 "prdwa17_backup"."channels"."videocount",
 0,
 0,
 0,
 0,
 0
 FROM "prdwa17_backup"."videos"
 INNER JOIN "prdwa17_backup"."channels"
 on "prdwa17_backup"."channels"."id" = "prdwa17_backup"."videos"."channelid"
 WHERE "prdwa17_backup"."videos".id not in (select code_video from "prdwa17_target"."t_videofacts");
 */
 
 --INSERTION DES FAITS VIDEO
 
 INSERT INTO "prdwa17_target"."t_videofacts" 
("code_videofact",
"code_video", 
"t_actualdate", 
"t_channelcommentscount",
"t_channelsubscribercount", 
"t_channelvideocount", 
"t_commentcount", 
"t_likecount", 
"t_dislikecount", 
"t_viewcount", 
"t_favoritecount")
SELECT DISTINCT "prdwa17_backup"."videos".id,
"prdwa17_backup"."videos".id,
 "prdwa17_backup"."videos"."fetchedat",
 "prdwa17_backup"."channels"."commentcount",
 "prdwa17_backup"."channels"."subscribercount",
 "prdwa17_backup"."channels"."videocount",
 "prdwa17_backup"."videos"."commentcount",
 "prdwa17_backup"."videos"."likecount",
 "prdwa17_backup"."videos"."dislikecount",
 "prdwa17_backup"."videos"."viewcount",
 "prdwa17_backup"."videos"."favoritecount"
 FROM "prdwa17_backup"."videos"
 INNER JOIN "prdwa17_backup"."channels"
 on "prdwa17_backup"."channels"."fetchedat" = "prdwa17_backup"."videos"."fetchedat" and "prdwa17_backup"."channels"."id" = "prdwa17_backup"."videos"."channelid";
 
 --INSERTION DES FAITS COMMENTAIRES
 
  INSERT INTO "prdwa17_target"."t_videocomment" 
 ("code_videocomment", 
 "code_video", 
 "t_actualdate", 
 "t_commentid", 
 "t_text_original", 
 "t_author", 
 "t_idcommentthread", 
 "t_likecount")  
 SELECT
 "prdwa17_backup"."videoscomments"."id",
 "prdwa17_backup"."videoscomments"."videoid", 
 "prdwa17_backup"."videoscomments"."fetchedat",
 "prdwa17_backup"."videoscomments"."id", 
 "prdwa17_backup"."videoscomments"."textoriginal",
 "prdwa17_backup"."videoscomments"."authorchannelid",
 "prdwa17_backup"."videoscomments"."parentid",
 "prdwa17_backup"."videoscomments"."likecount"

FROM "prdwa17_backup"."videoscomments" WHERE "prdwa17_backup"."videoscomments".id NOT IN (SELECT "code_videocomment" FROM "prdwa17_target"."t_videocomment");
 