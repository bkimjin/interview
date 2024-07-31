SELECT
    /* primary key */
    id

    /* foreign keys */
    , location_id
    , organization_id
    , team_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , title
    , job_status
    , employment_type
    , job_category
    , job_function
    
    /* booleans */
    , confidential AS is_confidential
FROM {{ source('stg', 'jobs') }}
