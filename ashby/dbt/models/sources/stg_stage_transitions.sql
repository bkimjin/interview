SELECT
    /* primary key */
    id

    /* foreign keys */
    , application_id -- joins to applications
    , new_interview_stage_id
    , organization_id
    , previous_interview_stage_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at
    , entered_stage_at::TIMESTAMPTZ AS entered_stage_at
    , left_stage_at::TIMESTAMPTZ AS left_stage_at
FROM {{ source('stg', 'stage_transitions') }}
