/*
    Join Time in Process data to other identifiers for categorization in visualization.
    Data aggregations are added in visualizations because:
        1. There are many, many ways to aggregate the data, and can be a distraction doing work that has low business impact.
        1. Defining aggregated fields here can cause dimension creep on BI tools. It's better to allow stakeholders to build their own charts w/ filters to aggregate the data.
        1. While this doesn't take advantage of the semantic layer, not all orgs prefer to work with dbt cloud and don't want to be locked in.
*/
SELECT
    /* primary key */
    {{ dbt_utils.generate_surrogate_key(['tip.id', 'jobs.location_id', 'stage_transitions.id']) }} AS id

    /* foreign keys */
    , tip.application_id
    , tip.candidate_id
    , tip.job_id
    , jobs.location_id
    , tip.organization_id
    , tip.source_id

    /* timestamps */
    , tip.application_begin_at
    , tip.application_end_at
    , stage_transitions.entered_stage_at
    , stage_transitions.left_stage_at
    , jobs.created_at AS job_created_at

    /* properties */
    , tip.status
    , interview_groups.stage_title
    , interview_groups.stage_group_type
    , tip.time_in_process_minutes
    , tip.time_in_process_days
    , {{ datediff("stage_transitions.entered_stage_at", "stage_transitions.left_stage_at", "second") }} AS time_in_stage_seconds

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
    , tip.is_review_required
    , teams.is_archived AS is_team_archived
    , sources.is_archived AS is_source_archived
    , source_types.is_archived AS is_source_type_archived
FROM {{ ref('int_time_in_process') }} AS tip
LEFT JOIN {{ ref('stg_jobs') }} AS jobs ON tip.job_id = jobs.id
LEFT JOIN {{ ref('int_team_category') }} AS teams ON jobs.team_id = teams.id
LEFT JOIN {{ ref('stg_stage_transitions') }} AS stage_transitions ON tip.id = stage_transitions.application_id
LEFT JOIN {{ ref('stg_interview_stages_and_groups') }} AS interview_groups ON stage_transitions.new_interview_stage_id = interview_groups.stage_id
LEFT JOIN {{ ref('stg_sources') }} AS sources ON tip.source_id = sources.id
LEFT JOIN {{ ref('stg_source_types') }} AS source_types ON sources.source_type_id = source_types.id