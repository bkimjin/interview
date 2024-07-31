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
