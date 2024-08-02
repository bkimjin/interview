/*
    Clean up raw data by organizing columns and type casting.
    Contains details about interview stages and stage group mappings.
*/
SELECT
    /* primary key */
    stage_id

    /* foreign keys */
    , interview_stage_group_id -- this does not connect to any available source
    , organization_id -- this does not connect to any available source
    , stage_group_id -- this does not connect to any available source

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , stage_group_order
    , stage_group_title
    , LOWER(stage_group_type) AS stage_group_type
    , stage_order
    , stage_type
    , LOWER(title) AS stage_title

    /* booleans */
    , archived AS is_archived
FROM {{ source('stg', 'interview_stages_and_groups') }}
