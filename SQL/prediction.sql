-- Prediction model creation 

-- Create ML table

create table prdwa17_target.VTEST (
   CODE_VIDEO           VARCHAR(255)              null,
   CT           VARCHAR(255)                 not null,
   TI        BIGINT                 null,
   C1        BIGINT                 null,
   C2       BIGINT                 null,
   C3         BIGINT                 null,
   primary key (CT)
)
DISTRIBUTE BY HASH(CT)
STORAGE ROW
COMPRESS LOW;

/*DELETE FROM prdwa17_ml.vtest;*/

-- Insert useful data (hourly avg of quantitative variables) into ML table

INSERT INTO prdwa17_ml.vtest (CT, TI, C1, C2, C3, CODE_VIDEO) SELECT imp.code_video||imp.ti, imp.ti, imp.c1, imp.c2, imp.c3, imp.code_video FROM (SELECT extract('day' from t_actualdate-v.t_publishedat)*24+extract('hour' from t_actualdate-v.t_publishedat) as ti, avg(t_viewcount) as c1, avg(t_likecount) as c2,avg(t_dislikecount) as c3 , vf.code_video 
		from prdwa17_target.t_videofacts as vf
		inner join prdwa17_target.t_video as v
		on vf.code_video = substring(v.code_video from 1 for 11)
		where extract('day' from t_actualdate-v.t_publishedat)*24+extract('hour' from t_actualdate-v.t_publishedat)>0 and extract('day' from t_actualdate-v.t_publishedat)*24+extract('hour' from t_actualdate-v.t_publishedat)<200
		group by vf.code_video,extract('day' from t_actualdate-v.t_publishedat)*24+extract('hour' from t_actualdate-v.t_publishedat)
		) as imp;

/*(SELECT * FROM Interpolator (
	ON prdwa17_ml.vtest
	PARTITION BY code_video 
	ORDER BY "ti"
	Time_Column ('ti')
	Time_Interval (1)
	Value_Columns ('c1','c2','c3')
	Interpolation_Type ('linear')
	Values_Before_First ('0')
	Values_After_Last ('0')
	Accumulate ('code_video')
	) as model)*/

	
-- Create the prediction model
SELECT * FROM Arima (
ON (SELECT 1)
PARTITION BY 1
InputTable ('prdwa17_ml.vtest')
ModelTable ('prdwa17_ml.arimamodel')
TimestampColumns ('ti')
ValueColumn ('c2')
Orders ('3,0,0')
);
