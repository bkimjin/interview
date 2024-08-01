/*
    Clean up raw data by organizing columns and type casting.
    Contains detail about the job itself.
    
    Relationships
    1:1 with applications
    1:1 with teams
*/
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
