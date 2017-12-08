--un exemple de actualdate:2017-11-23 16:30:08.000000

--on fix actualdate = un de fetchedAT dans table de base de staging
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
"t_season") VALUES (actualdate,?,?,?,?,?,?,?,?,?);
 	
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
 SELECT  "prdwa17_staging"."videos_test"."id" || to_char("prdwa17_staging"."videos_test"."fetchedat",'YYYY-Mon-DD HH12:MI:SS'),
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
 WHERE "prdwa17_staging"."channels_test"."fetchedat" = actualdate
 AND "prdwa17_staging"."videos_test"."fetchedat" = actualdate;

--table de fiat t-videofacts
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
"prdwa17_staging"."videos"."screenshot",
"prdwa17_staging"."videos"."screenshot", 
"prdwa17_staging"."videos"."fetchedat",
"prdwa17_staging"."channels"."commentcount",
"prdwa17_staging"."channels"."subscribercount", 
"prdwa17_staging"."channels"."videocount", 
"prdwa17_staging"."videos"."commentcount", 
"prdwa17_staging"."videos"."likecount", 
"prdwa17_staging"."videos"."dislikecount",
"prdwa17_staging"."videos"."viewcount",
"prdwa17_staging"."videos"."favoritecount"

 FROM "prdwa17_staging"."channels"
 INNER JOIN "prdwa17_staging"."videos"
 on "prdwa17_staging"."channels"."id" = "prdwa17_staging"."videos"."channelid"
 WHERE "prdwa17_staging"."channels"."fetchedat" = actualdate
 AND "prdwa17_staging"."videos"."fetchedat" = actualdate;

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
 "prdwa17_staging"."videoscomments"."screenshot",
 "prdwa17_staging"."videos"."screenshot", 
 "prdwa17_staging"."videoscomments"."fetchedat",
 "prdwa17_staging"."videoscomments"."id", 
 "prdwa17_staging"."videoscomments"."textoriginal",
 "prdwa17_staging"."videoscomments"."authorchannelid",
 "prdwa17_staging"."videoscomments"."parentid",
 "prdwa17_staging"."videoscomments"."likecount"

 FROM "prdwa17_staging"."videos"
 INNER JOIN "prdwa17_staging"."videoscomments"
 on "prdwa17_staging"."videos"."id" = "prdwa17_staging"."videoscomments"."videoid"
 WHERE "prdwa17_staging"."videos"."fetchedat" = actualdate
 AND "prdwa17_staging"."videoscomments"."fetchedat" = actualdate;



