/*MERGE 
    INTO prdwa17_target.video_facts AS TARGET
    USING prdwa17_staging.video AS SOURCE
    ON TARGET.video_id = SOURCE.video_id
    --WHEN MATCHED
    --    THEN UPDATE???
    WHEN NOT MATCHED BY TARGET
        THEN INSERT (Id , LastName , FirstName, HouseNumber)
    VALUES (SOURCE.Id , SOURCE.LastName , SOURCE.FirstName, SOURCE.HouseNumber)
    -- WHEN NOT MATCHED BY SOURCE
    --    THEN DELETE???
;*/

MERGE 
    INTO prdwa17_target.tags AS TARGET
    USING (SELECT id, title FROM prdwa17_staging.YouTubeTags) AS SOURCE
    ON TARGET.tags.code_tag = SOURCE.id
    --WHEN MATCHED
    --    THEN UPDATE???
    WHEN NOT MATCHED
        THEN INSERT (code_tag, title)
    VALUES (SOURCE.id , SOURCE.title)
    -- WHEN NOT MATCHED BY SOURCE
    --    THEN DELETE???
;

SELECT id,
	viewCount,
	commentCount,
	likeCount,
	dislikeCount,
	favoriteCount,
	viewCount,
	commentCount,
	subscriberCount,
	videoCount 
	FROM prdwa17_staging.videos 
	INNER JOIN prdwa17_staging.channels 
	WHERE prdwa17_staging.videos.channelId=prdwa17_staging.channels.id AND prdwa17_staging.videos.fetchedAt=prdwa17_staging.channels.fetchedAt
	AS Results;

INSERT INTO prdwa17_target.t_videofacts (code_video,t_viewcount, t_commentcount, t_likecount,t_dislikecount,t_favoritecount,t_actualdate, t_channelcommentscount, t_channelsubscribercount, t_channelvideocount)
SELECT v.id,
	v.viewCount,
	v.commentCount,
	v.likeCount,
	v.dislikeCount,
	v.favoriteCount,
	v.fetchedAt,
	c.commentCount,
	c.subscriberCount,
	c.videoCount 
	FROM prdwa17_staging.videos as v
	INNER JOIN prdwa17_staging.channels as c
	ON v.channelid=c.id AND v.fetchedAt=c.fetchedAt;