/*
    Clean up raw data by organizing columns and type casting.
    Details on the source types.
    
    Relationships
    1:many with sources
*/
SELECT
    /* primary key */
    id

    /* foreign keys */
    , organization_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , LOWER(title) AS title

    /* booleans */
    , is_archived
FROM {{ source('stg', 'source_types') }}
