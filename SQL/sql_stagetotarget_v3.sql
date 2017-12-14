--un exemple de actualdate:2017-11-23 16:30:08.000000

--faut initialiser d'abord tous les temps de fetch dans le table de dimension t_time
--"prdwa17_staging"."videos_test"."fetchedat"
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
"t_season") VALUES (？,?,?,?,?,?,?,?,?,?);
 	
--on divise le table de staging par fetchdat

--T-video dimension table
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
 SELECT "prdwa17_staging"."videos_test"."id",
 "prdwa17_staging"."videos_test"."title",
 "prdwa17_staging"."videos_test"."id", 
 "prdwa17_staging"."videos_test"."description",
 "prdwa17_staging"."videos_test"."publishedat", 
 "prdwa17_staging"."channels_test"."id", 
 "prdwa17_staging"."channels_test"."title",
 "prdwa17_staging"."channels_test"."description", 
 "prdwa17_staging"."videos_test"."topiccategory_1", 
 "prdwa17_staging"."videos_test"."topiccategory_2", 
 "prdwa17_staging"."videos_test"."topiccategory_3"

 FROM "prdwa17_staging"."channels_test"
 INNER JOIN "prdwa17_staging"."videos_test"
 on "prdwa17_staging"."channels_test"."id" = "prdwa17_staging"."videos_test"."channelid"
 WHERE extract('hour' FROM "prdwa17_staging"."channels_test"."fetchedat") = extract('hour' FROM "prdwa17_staging"."videos_test"."fetchedat")
 and  "prdwa17_staging"."videos_test"."id" NOT IN (select code_video from "prdwa17_target"."t_video");

--table de fait t-videofacts
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
SELECT  
"prdwa17_staging"."videos_test"."id" || "prdwa17_staging"."videos_test"."fetchedat",
"prdwa17_staging"."videos_test"."id",
"prdwa17_staging"."videos_test"."fetchedat",
"prdwa17_staging"."channels_test"."commentcount",
"prdwa17_staging"."channels_test"."subscribercount", 
"prdwa17_staging"."channels_test"."videocount", 
"prdwa17_staging"."videos_test"."commentcount", 
"prdwa17_staging"."videos_test"."likecount", 
"prdwa17_staging"."videos_test"."dislikecount",
"prdwa17_staging"."videos_test"."viewcount",
"prdwa17_staging"."videos_test"."favoritecount"

 FROM "prdwa17_staging"."channels_test"
 INNER JOIN "prdwa17_staging"."videos_test"
 on "prdwa17_staging"."channels_test"."id" = "prdwa17_staging"."videos_test"."channelid"
 WHERE extract('hour' FROM "prdwa17_staging"."channels_test"."fetchedat") = extract('hour' FROM "prdwa17_staging"."videos_test"."fetchedat")
 and  "prdwa17_staging"."videos_test"."fetchedat" NOT IN (select t_actualdate from "prdwa17_target"."t_videofacts");

--table de fait t-videocomment
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
 "prdwa17_staging"."videoscomments_test"."id" || "prdwa17_staging"."videos_test"."fetchedat",
 "prdwa17_staging"."videos_test"."id", 
 "prdwa17_staging"."videos_test"."fetchedat",
 "prdwa17_staging"."videoscomments_test"."id", 
 "prdwa17_staging"."videoscomments_test"."textoriginal",
 "prdwa17_staging"."videoscomments_test"."authorchannelid",
 "prdwa17_staging"."videoscomments_test"."parentid",
 "prdwa17_staging"."videoscomments_test"."likecount"

 FROM "prdwa17_staging"."videos_test"
 INNER JOIN "prdwa17_staging"."videoscomments_test"
 on "prdwa17_staging"."videos_test"."id" = "prdwa17_staging"."videoscomments_test"."videoid"
 WHERE extract('hour' FROM "prdwa17_staging"."videoscomments_test"."fetchedat") = extract('hour' FROM "prdwa17_staging"."videos_test"."fetchedat")
 and  "prdwa17_staging"."videos_test"."fetchedat" NOT IN (select  t_actualdate from "prdwa17_target"."t_videocomment");


