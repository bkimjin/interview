/*
    Clean up raw data by organizing columns and type casting.
    Details on the team. Teams can join to itself via parent_team_id.
    
    Relationships
    1:1 with jobs
    1:many with teams (parent_team_id)
*/
SELECT
    /* primary key */
    id

    /* foreign keys */
    , organization_id
    , parent_team_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , team_name

    /* booleans */
    , is_archived
FROM {{ source('stg', 'teams') }}
