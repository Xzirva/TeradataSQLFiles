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
