/*
    Get Time in Process per application, 
    - Application status must be archived or hired for the overal TiP
        - Exclude applicants that are not completed because they may skew the result
    1. Total TiP for archived and hired applicants
        1. Filter by `stg_applications.status in ('archived', 'hired')`
        1. Join `stg_applications.id = stg_stage_transitions.application_id`
        1. Join `stg_interview_stages_and_groups.stage_id = stg_stage_transitions.new_stage_id`
        1. Filter by `stg_interview_stages_and_groups.stage_group_type in ('archived', 'hired')`
*/

SELECT
    /* primary key */
    applications.id AS id

    /* foreign keys */
    , applications.id AS application_id
    , applications.organization_id
    , applications.job_id
    , applications.candidate_id
    , applications.source_id

    /* timestamps */
    , applications.created_at AS application_begin_at
    , stage_transitions.entered_stage_at AS application_end_at

    /* properties */
    , applications.status
    , {{ datediff("application_begin_at", "application_end_at", "minute") }} AS time_in_process_minutes
    , {{ datediff("application_begin_at", "application_end_at", "day") }} AS time_in_process_days

    /* boolean */
    -- These applications have a time difference of less than 1 minute, which may need to be reviewed to verify they were closed correctly.
    , CASE WHEN time_in_process_minutes < 1 THEN TRUE ELSE FALSE END AS is_review_required
FROM {{ ref('stg_applications') }} AS applications
LEFT JOIN {{ ref('stg_stage_transitions') }} AS stage_transitions ON applications.id = stage_transitions.application_id
LEFT JOIN {{ ref('stg_interview_stages_and_groups') }} AS interview_groups ON stage_transitions.new_interview_stage_id = interview_groups.stage_id
/* The WHERE & QUALIFY statements handle the use case of when candidates are archived and then unarchived.
If an application is archived, then it will be captured by both where statements. If the application
is then subsequently unarchived, it will not be captured by the first where statement, until they are
archived again, at which the QUALIFY statement will grab the correct actual archived/hired timestamp.
*/
WHERE
    -- Optimize query to pull less rows before joining
    applications.status IN ('archived', 'hired')
    -- Return rows that are being used
    AND interview_groups.stage_group_type IN ('archived', 'hired')
-- If an application has multiple archived or hired status per applicant, get the latest one.
QUALIFY ROW_NUMBER() OVER (PARTITION BY application_id ORDER BY application_end_at DESC) = 1