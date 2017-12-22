/*
CREATE SCHEMA prdwa17_test;
CREATE SCHEMA prdwa17_target; -- Made for dimensions and facts
CREATE SCHEMA prdwa17_ml; -- Made for machines learning results calculated from target*/
/*DROP TABLE prdwa17_test.channels;
DROP TABLE prdwa17_test.videos;
DROP TABLE prdwa17_test.videosComments;
DROP TABLE prdwa17_test.YouTubeTags;*/
--ALTER TABLE prdwa17_test.videosComments RENAME COLUMN textdisplay TO textoriginal;
CREATE TABLE prdwa17_test.channels (
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

CREATE TABLE prdwa17_test.videos (
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

CREATE TABLE prdwa17_test.videosComments (
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

select distinct id, count(1) from prdwa17_test.videoscomments where videoid = 'Ir4Ltgj4o84' group by id;
select * from prdwa17_test.videoscomments where id = 'UgzdCtLd6ibdj3HPgYp4AaABAg';
