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
 SELECT DISTINCT "prdwa17_staging"."videos"."id" as code_video,
 "prdwa17_staging"."videos"."title",
 "prdwa17_staging"."videos"."id", 
 "prdwa17_staging"."videos"."description",
 "prdwa17_staging"."videos"."publishedat", 
 "prdwa17_staging"."channels"."id" as channelid, 
 "prdwa17_staging"."channels"."title" as channeltitle,
 "prdwa17_staging"."channels"."description" as channeldescription,
 LTRIM("prdwa17_staging"."videos"."topiccategory_1",'https://en.wikipedia.org/wiki/') as t1,
 LTRIM("prdwa17_staging"."videos"."topiccategory_2",'https://en.wikipedia.org/wiki/') as t2,
 LTRIM("prdwa17_staging"."videos"."topiccategory_3",'https://en.wikipedia.org/wiki/') as t3,
 row_number() over (partition by "prdwa17_staging"."videos"."id" order by "prdwa17_staging"."videos"."id") as rownumber

 FROM "prdwa17_staging"."videos"
 INNER JOIN "prdwa17_staging"."channels"
 on "prdwa17_staging"."channels"."id" = "prdwa17_staging"."videos"."channelid") as v
 where v.rownumber = 1
 and v.id not in (select code_video from "prdwa17_target"."t_video");
 
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
 from (SELECT DISTINCT "prdwa17_staging"."videos"."id" as code_video,
 "prdwa17_staging"."videos"."title",
 "prdwa17_staging"."videos"."id", 
 "prdwa17_staging"."videos"."description",
 "prdwa17_staging"."videos"."publishedat", 
 "prdwa17_staging"."channels"."id" as channelid, 
 "prdwa17_staging"."channels"."title" as channeltitle,
 "prdwa17_staging"."channels"."description" as channeldescription
 FROM "prdwa17_staging"."videos"
 INNER JOIN "prdwa17_staging"."channels"
 on "prdwa17_staging"."channels"."id" = "prdwa17_staging"."videos"."channelid") as v
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
SELECT DISTINCT "prdwa17_staging"."videos".fetchedat,
 extract('year' FROM "prdwa17_staging"."videos"."fetchedat"),
 extract('month' FROM "prdwa17_staging"."videos"."fetchedat"),
 extract('week' FROM "prdwa17_staging"."videos"."fetchedat"),
 extract('day' FROM "prdwa17_staging"."videos"."fetchedat"),
 extract('hour' FROM "prdwa17_staging"."videos"."fetchedat"),
 extract('minutes' FROM "prdwa17_staging"."videos"."fetchedat"),
 extract('seconds' FROM "prdwa17_staging"."videos"."fetchedat"),
 4,
 4
 FROM "prdwa17_staging"."videos"
 WHERE "prdwa17_staging"."videos".fetchedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
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
SELECT DISTINCT "prdwa17_staging"."videoscomments".fetchedat,
 extract('year' FROM "prdwa17_staging"."videoscomments"."fetchedat"),
 extract('month' FROM "prdwa17_staging"."videoscomments"."fetchedat"),
 extract('week' FROM "prdwa17_staging"."videoscomments"."fetchedat"),
 extract('day' FROM "prdwa17_staging"."videoscomments"."fetchedat"),
 extract('hour' FROM "prdwa17_staging"."videoscomments"."fetchedat"),
 extract('minutes' FROM "prdwa17_staging"."videoscomments"."fetchedat"),
 extract('seconds' FROM "prdwa17_staging"."videoscomments"."fetchedat"),
 4,
 4
 FROM "prdwa17_staging"."videoscomments"
 WHERE "prdwa17_staging"."videoscomments".fetchedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
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
SELECT DISTINCT "prdwa17_staging"."videos".publishedat,
 extract('year' FROM "prdwa17_staging"."videos"."publishedat"),
 extract('month' FROM "prdwa17_staging"."videos"."publishedat"),
 extract('week' FROM "prdwa17_staging"."videos"."publishedat"),
 extract('day' FROM "prdwa17_staging"."videos"."publishedat"),
 extract('hour' FROM "prdwa17_staging"."videos"."publishedat"),
 extract('minutes' FROM "prdwa17_staging"."videos"."publishedat"),
 extract('seconds' FROM "prdwa17_staging"."videos"."publishedat"),
 4,
 4
 FROM "prdwa17_staging"."videos"
 WHERE "prdwa17_staging"."videos".publishedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
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
SELECT DISTINCT "prdwa17_staging"."videoscomments".publishedat,
 extract('year' FROM "prdwa17_staging"."videoscomments"."publishedat"),
 extract('month' FROM "prdwa17_staging"."videoscomments"."publishedat"),
 extract('week' FROM "prdwa17_staging"."videoscomments"."publishedat"),
 extract('day' FROM "prdwa17_staging"."videoscomments"."publishedat"),
 extract('hour' FROM "prdwa17_staging"."videoscomments"."publishedat"),
 extract('minutes' FROM "prdwa17_staging"."videoscomments"."publishedat"),
 extract('seconds' FROM "prdwa17_staging"."videoscomments"."publishedat"),
 4,
 4
 FROM "prdwa17_staging"."videoscomments"
 WHERE "prdwa17_staging"."videoscomments".publishedat not in (select t_actualdate from "prdwa17_target"."t_time");
 
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
SELECT DISTINCT "prdwa17_staging"."videos".id,
"prdwa17_staging"."videos".id,
 "prdwa17_staging"."videos"."publishedat",
 "prdwa17_staging"."channels"."commentcount",
 "prdwa17_staging"."channels"."subscribercount",
 "prdwa17_staging"."channels"."videocount",
 0,
 0,
 0,
 0,
 0
 FROM "prdwa17_staging"."videos"
 INNER JOIN "prdwa17_staging"."channels"
 on "prdwa17_staging"."channels"."id" = "prdwa17_staging"."videos"."channelid"
 WHERE "prdwa17_staging"."videos".id not in (select code_video from "prdwa17_target"."t_videofacts");
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
SELECT DISTINCT "prdwa17_staging"."videos".id,
"prdwa17_staging"."videos".id,
 "prdwa17_staging"."videos"."fetchedat",
 "prdwa17_staging"."channels"."commentcount",
 "prdwa17_staging"."channels"."subscribercount",
 "prdwa17_staging"."channels"."videocount",
 "prdwa17_staging"."videos"."commentcount",
 "prdwa17_staging"."videos"."likecount",
 "prdwa17_staging"."videos"."dislikecount",
 "prdwa17_staging"."videos"."viewcount",
 "prdwa17_staging"."videos"."favoritecount"
 FROM "prdwa17_staging"."videos"
 INNER JOIN "prdwa17_staging"."channels"
 on "prdwa17_staging"."channels"."fetchedat" = "prdwa17_staging"."videos"."fetchedat" and "prdwa17_staging"."channels"."id" = "prdwa17_staging"."videos"."channelid";
 
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
 "prdwa17_staging"."videoscomments"."id",
 "prdwa17_staging"."videoscomments"."videoid", 
 "prdwa17_staging"."videoscomments"."fetchedat",
 "prdwa17_staging"."videoscomments"."id", 
 "prdwa17_staging"."videoscomments"."textoriginal",
 "prdwa17_staging"."videoscomments"."authorchannelid",
 "prdwa17_staging"."videoscomments"."parentid",
 "prdwa17_staging"."videoscomments"."likecount"

FROM "prdwa17_staging"."videoscomments" WHERE "prdwa17_staging"."videoscomments".id NOT IN (SELECT "code_videocomment" FROM "prdwa17_target"."t_videocomment");
 