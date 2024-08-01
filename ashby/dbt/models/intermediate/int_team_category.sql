/*
    This model attempts to get the top most parent for department categorization.
    Based on a quick analysis, there are not a lot of orgs that make use of parent teams.
*/

WITH RECURSIVE team_hierarchy AS (
    SELECT
        id
        , parent_team_id
        , team_name
        , team_name AS department_name
        , organization_id
        , is_archived
    FROM {{ ref('stg_teams') }}
    WHERE parent_team_id IS NULL

    UNION ALL
       
    SELECT
        teams.id
        , teams.parent_team_id
        , teams.team_name
        , team_hierarchy.department_name
        , teams.organization_id
        , teams.is_archived
    FROM {{ ref('stg_teams') }} AS teams
    JOIN team_hierarchy on teams.parent_team_id = team_hierarchy.id
)
       
SELECT *
FROM team_hierarchy