SELECT
    /* primary key */
    stage_id

    /* foreign keys */
    , interview_stage_group_id
    , organization_id
    , stage_group_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , stage_group_order
    , stage_group_title
    , stage_group_type
    , stage_order
    , stage_type
    , title

    /* booleans */
    , archived AS is_archived
FROM {{ source('stg', 'interview_stages_and_groups') }}
