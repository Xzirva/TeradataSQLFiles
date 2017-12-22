
CREATE SCHEMA prdwa17_backup;
CREATE TABLE prdwa17_backup.channels (
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

CREATE TABLE prdwa17_backup.videos (
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

CREATE TABLE prdwa17_backup.videosComments (
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


insert into prdwa17_backup.channels
select * from prdwa17_staging.channels;

insert into prdwa17_backup.videos
select * from prdwa17_staging.videos;

insert into prdwa17_backup.videoscomments
select * from prdwa17_staging.videoscomments;