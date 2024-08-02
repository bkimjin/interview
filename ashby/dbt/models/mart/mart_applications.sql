/*
    This model looks at all applications and attempts to answer any potential questions related to them.
*/
SELECT
    /* primary key */
    {{ dbt_utils.generate_surrogate_key(['applications.id', 'jobs.id', 'stage_transitions.id']) }} AS id

    /* foreign keys */
    , applications.id AS application_id
    , applications.candidate_id
    , applications.job_id
    , jobs.location_id
    , applications.organization_id
    , applications.source_id

    /* timestamps */
    , applications.created_at AS application_begin_at
    , stage_transitions.entered_stage_at
    , stage_transitions.left_stage_at
    , jobs.created_at AS job_created_at

    /* properties */
    , applications.status
    , interview_groups.stage_title
    , interview_groups.stage_group_type
    , {{ datediff("stage_transitions.entered_stage_at", "stage_transitions.left_stage_at", "day") }} AS time_in_stage_days
    , {{ datediff("stage_transitions.entered_stage_at", "stage_transitions.left_stage_at", "minute") }} AS time_in_stage_minutes

    /* job properties */
    , jobs.title
    , jobs.job_status
    , jobs.employment_type
    , jobs.job_category
    , jobs.job_function

    /* team properties */
    , teams.department_name

    /* source properties */
    , sources.title AS source_name
    , source_types.title AS source_type_name

    /* booleans */
    , jobs.is_confidential AS is_job_confidential
    , teams.is_archived AS is_team_archived
    , sources.is_archived AS is_source_archived
    , source_types.is_archived AS is_source_type_archived
FROM {{ ref('stg_applications') }} AS applications
LEFT JOIN {{ ref('stg_jobs') }} AS jobs ON applications.job_id = jobs.id
LEFT JOIN {{ ref('int_team_category') }} AS teams ON jobs.team_id = teams.id
LEFT JOIN {{ ref('stg_stage_transitions') }} AS stage_transitions ON applications.id = stage_transitions.application_id
LEFT JOIN {{ ref('stg_interview_stages_and_groups') }} AS interview_groups ON stage_transitions.new_interview_stage_id = interview_groups.stage_id
LEFT JOIN {{ ref('stg_sources') }} AS sources ON applications.source_id = sources.id
LEFT JOIN {{ ref('stg_source_types') }} AS source_types ON sources.source_type_id = source_types.id