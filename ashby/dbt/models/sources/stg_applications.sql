/* Clean up raw data by organization and type casting. */
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
    , status

FROM {{ source('stg', 'applications') }}