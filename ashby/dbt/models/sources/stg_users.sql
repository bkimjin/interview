/*
    While it appears that users can be used for the other data sources, there is no way to join the data to the other datasets.
*/
SELECT
    /* primary key */
    id

    /* foreign keys */
    , organization_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , global_role

    /* booleans */
    , enabled AS is_enabled
FROM {{ source('stg', 'users') }}