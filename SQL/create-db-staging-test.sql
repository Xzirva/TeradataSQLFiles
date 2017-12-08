/*
CREATE SCHEMA prdwa17_staging; -- Made for prior 'staging' before ETL to target
CREATE SCHEMA prdwa17_target; -- Made for dimensions and facts
CREATE SCHEMA prdwa17_ml; -- Made for machines learning results calculated from target*/
--select distinct id from prdwa17_staging.videoscomments where videoid = 'ePu__TvdjNQ' order by id desc;
/*DROP TABLE prdwa17_staging.channels;
DROP TABLE prdwa17_staging.videos;
DROP TABLE prdwa17_staging.videosComments;
DROP TABLE prdwa17_staging.YouTubeTags;*/
--ALTER TABLE prdwa17_staging.videosComments RENAME COLUMN textdisplay TO textoriginal;
CREATE TABLE prdwa17_staging.channels_test (
	id VARCHAR(100),
	title VARCHAR(255),
	description TEXT,
	publishedAt TIMESTAMP,
	viewCount BIGINT,
	commentCount BIGINT,
	subscriberCount BIGINT,
	videoCount BIGINT,
	topicCategory_1 VARCHAR(255),
	topicCategory_2 VARCHAR(255),
	topicCategory_3 VARCHAR(255),
	keywords TEXT,
	fetchedAt TIMESTAMP
) DISTRIBUTE BY HASH(id);
--7609
CREATE TABLE prdwa17_staging.videos_test (
-- 	dbId BIGSERIAL LOCAL,
	id VARCHAR(100),
	channelId VARCHAR(100),
	title VARCHAR(255),
	description TEXT,
	publishedAt TIMESTAMP,
	viewCount BIGINT,
	commentCount BIGINT,
	likeCount BIGINT,
	dislikeCount BIGINT,
	favoriteCount BIGINT,
	duration VARCHAR(10),
	categoryId VARCHAR(10),
	topicCategory_1 VARCHAR(255),
	topicCategory_2 VARCHAR(255),
	topicCategory_3 VARCHAR(255),
	fetchedAt TIMESTAMP
)DISTRIBUTE BY HASH(id);

CREATE TABLE prdwa17_staging.videosComments_test (
	-- dbId BIGSERIAL LOCAL PRIMARY KEY,
	id VARCHAR(100),
	authorChannelurl VARCHAR(255),
	authorDisplayedName VARCHAR(225),
	authorChannelId VARCHAR(100),
	videoId VARCHAR(100),
	parentId VARCHAR(100),
	textOriginal TEXT,
	likeCount INT,
	publishedAt TIMESTAMP,
	fetchedAt TIMESTAMP
) DISTRIBUTE BY HASH(id);