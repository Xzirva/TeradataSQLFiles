/*==============================================================*/
/* Nom de SGBD :  PostgreSQL 9.x                                */
/* Date de création :  17/11/2017 14:33:06                      */
/*==============================================================*/

/*
drop index TAGS_PK;

drop table TAGS;

drop index T_TIME_PK;

drop table T_TIME;

drop index T_VIDEO_PK;

drop table T_VIDEO;

drop index RELATION_7_FK;

drop index RELATION_6_FK;

drop index T_VIDEOCOMMENT_PK;

drop table T_VIDEOCOMMENT;

drop index RELATION_5_FK;

drop index RELATION_4_FK;

drop index RELATION_3_FK;

drop index T_VIDEOFACTS_PK;

drop table T_VIDEOFACTS;

*/

drop table prdwa17_target.T_VIDEO;
drop table prdwa17_target.T_TIME;
drop table prdwa17_target.T_VIDEOCOMMENT;
drop table prdwa17_target.T_VIDEOFACTS;
/*==============================================================*/
/* Table : TAGS                                                 */
/*==============================================================*/


/*==============================================================*/
/* Index : TAGS_PK                                              */
/*==============================================================
create unique index TAGS_PK on prdwa17_target.TAGS (
CODE_TAG
);
*/
/*==============================================================*/
/* Table : T_TIME                                               */
/*==============================================================*/
create dimension table prdwa17_target.T_TIME (
   T_ACTUALDATE         VARCHAR(25)                 not null,
   T_YEAR               INT2                 null,
   T_MONTH              INT2                 null,
   T_WEEK               INT2                 null,
   T_DAY                INT2                 null,
   T_HOUR               INT2                 null,
   T_MINUTES            INT2                 null,
   T_SECONDS            INT2                 null,
   T_TRIMESTER          INT2                 null,
   T_SEASON             INT2                 null,
   primary key (T_ACTUALDATE)
);



/*==============================================================*/
/* Index : T_TIME_PK                                            */
/*==============================================================
create unique index T_TIME_PK on prdwa17_target.T_TIME (
T_ACTUALDATE
);*/

/*==============================================================*/
/* Table : T_VIDEO                                              */
/*==============================================================*/
create dimension table prdwa17_target.T_VIDEO (
   CODE_VIDEO           VARCHAR(25)              not null,
   T_TITLE              VARCHAR(255)                null,
   T_VIDEOID            VARCHAR(11)          null,
   T_DESCRIPTION        TEXT                 null,
   T_CUSTOMURL          TEXT                 null,
   T_CATEGORY           TEXT                 null,
   T_PUBLISHEDAT        DATE                 null,
   T_DURATION           INT4                 null,
   T_CHANNELID          VARCHAR(100)          null,
   T_CHANNELTITLE       TEXT                 null,
   T_CHANNELDESCRIPTION TEXT                 null,
   T_CHANNELCUSTOMURL   TEXT                 null,
   T_TOPICCATEGORIE1    TEXT                 null,
   T_TOPICCATEGORIE2    TEXT                 null,
   T_TOPICCATEGORIE3    TEXT                 null,
   primary key (CODE_VIDEO)
)
DISTRIBUTE BY REPLICATION;


/*==============================================================*/
/* Index : T_VIDEO_PK                                           */
/*==============================================================
create unique index T_VIDEO_PK on prdwa17_target.T_VIDEO (
CODE_VIDEO
);*/

/*==============================================================*/
/* Table : T_VIDEOCOMMENT                                       */
/*==============================================================*/

create fact table prdwa17_target.T_VIDEOCOMMENT (

   CODE_VIDEOCOMMENT	 	VARCHAR(25)		not null,/* prdwa17_staging.videosComments.screenshot*/
   CODE_VIDEO           INT4                 not null,
   T_ACTUALDATE         VARCHAR(25)           not null,
   CODE_COMMENT         INT4                 not null,
   T_COMMENTID          VARCHAR(11)          null,
   T_TEXT_DISPLAY       TEXT                 null,
   T_TEXT_ORIGINAL      TEXT                 null,
   T_AUTHOR             INT8                 null,
   T_ISPUBLICCOMMENTTHREAD BOOL                 null,
   T_IDCOMMENTTHREAD    VARCHAR(11)          null,
   T_LIKECOUNT INT8 null,
   primary key (CODE_VIDEOCOMMENT)
)
DISTRIBUTE BY HASH(CODE_VIDEOCOMMENT)
STORAGE ROW
COMPRESS LOW;

/*==============================================================*/
/* Index : T_VIDEOCOMMENT_PK                                    */
/*==============================================================
create unique index T_VIDEOCOMMENT_PK on prdwa17_target.T_VIDEOCOMMENT (
CODE_VIDEO,
T_ACTUALDATE,
CODE_COMMENT
);*/

/*==============================================================*/
/* Index : RELATION_6_FK                                        */
/*==============================================================
create  index RELATION_6_FK on prdwa17_target.T_VIDEOCOMMENT (
CODE_VIDEO
);*/

/*==============================================================*/
/* Index : RELATION_7_FK                                        */
/*==============================================================
create  index RELATION_7_FK on prdwa17_target.T_VIDEOCOMMENT (
T_ACTUALDATE
);
*/
/*==============================================================*/
/* Table : T_VIDEOFACTS                                         */
/*==============================================================*/
create fact table prdwa17_target.T_VIDEOFACTS (
   CODE_VIDEOFACT		   VARCHAR(25)    not null,/*prdwa17_staging.videos.screenshot*/
   CODE_VIDEO           INT4                not null,
   T_ACTUALDATE         VARCHAR(25)               not null,
   CODE_TAG             INT4                 not null,
   T_CHANNELCOMMENTSCOUNT BIGINT                 null,
   T_CHANNELSUBSCRIBERCOUNT BIGINT                 null,
   T_CHANNELVIDEOCOUNT  BIGINT                 null,
   T_COMMENTCOUNT       BIGINT                 null,
   T_LIKECOUNT          BIGINT                 null,
   T_DISLIKECOUNT       BIGINT                 null,
   T_VIEWCOUNT          BIGINT                 null,
   T_FAVORITECOUNT      BIGINT                 null,
   primary key (CODE_VIDEOFACT)
)
DISTRIBUTE BY HASH(CODE_VIDEOFACT)
STORAGE ROW
COMPRESS LOW;


/*==============================================================*/
/* Index : T_VIDEOFACTS_PK                                      */
/*==============================================================
create unique index T_VIDEOFACTS_PK on prdwa17_target.T_VIDEOFACTS (
CODE_VIDEO,
T_ACTUALDATE,
CODE_TAG
);*/

/*==============================================================*/
/* Index : RELATION_3_FK                                        */
/*==============================================================
create  index RELATION_3_FK on prdwa17_target.T_VIDEOFACTS (
CODE_VIDEO
);

/*==============================================================*/
/* Index : RELATION_4_FK                                        */
/*==============================================================
create  index RELATION_4_FK on prdwa17_target.T_VIDEOFACTS (
T_ACTUALDATE
);

/*==============================================================*/
/* Index : RELATION_5_FK                                        */
/*==============================================================
create  index RELATION_5_FK on prdwa17_target.T_VIDEOFACTS (
CODE_TAG
);*/

/*alter table prdwa17_target.T_VIDEOCOMMENT
   add constraint FK_T_VIDEOC_RELATION__T_VIDEO foreign key (CODE_VIDEO)
      references prdwa17_target.T_VIDEO (CODE_VIDEO);

alter table prdwa17_target.T_VIDEOCOMMENT
   add constraint FK_T_VIDEOC_RELATION__T_TIME foreign key (T_ACTUALDATE)
      references prdwa17_target.T_TIME (T_ACTUALDATE);

alter table prdwa17_target.T_VIDEOFACTS
   add constraint FK_T_VIDEOF_RELATION__T_VIDEO foreign key (CODE_VIDEO)
      references prdwa17_target.T_VIDEO (CODE_VIDEO);

alter table prdwa17_target.T_VIDEOFACTS
   add constraint FK_T_VIDEOF_RELATION__T_TIME foreign key (T_ACTUALDATE)
      references prdwa17_target.T_TIME (T_ACTUALDATE);

alter table prdwa17_target.T_VIDEOFACTS
   add constraint FK_T_VIDEOF_RELATION__TAGS foreign key (CODE_TAG)
      references prdwa17_target.TAGS (CODE_TAG);*/

