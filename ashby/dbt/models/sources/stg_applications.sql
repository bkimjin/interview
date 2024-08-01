/*
    Clean up raw data by organizing columns and type casting.
    Contains data about the candidate application details.
*/
SELECT
    /* primary key */
    id

    /* foreign keys */
    , archive_reason_id
    , organization_id
    , job_id
    , candidate_id
    , current_interview_stage_id
    , source_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at
    , last_activity_at::TIMESTAMPTZ AS last_activity_at
    
    /* properties */
    , lower(status) AS status

FROM {{ source('stg', 'applications') }}