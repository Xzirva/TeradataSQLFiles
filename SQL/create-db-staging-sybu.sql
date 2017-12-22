create schema prdwa17_batch_load; 
CREATE TABLE prdwa17_batch_load.channels (
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

CREATE TABLE prdwa17_batch_load.videos (
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

CREATE TABLE prdwa17_batch_load.videosComments (
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


---------------------------------------------------------------------------------
select left(to_char(fetchedat, 'FMDay, FMDD HH12:MI:SS'),  CHARINDEX(',', to_char(fetchedat, 'FMDay, FMDD HH12:MI:SS')) - 1) from prdwa17_batch_load.videos;