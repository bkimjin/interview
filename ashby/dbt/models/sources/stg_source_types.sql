SELECT
    /* primary key */
    id

    /* foreign keys */
    , organization_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , title

    /* booleans */
    , is_archived
FROM {{ source('stg', 'source_types') }}
