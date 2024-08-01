/*
    Clean up raw data by organizing columns and type casting.
    Details on the source. Individual source details are omitted except the source ID. 1 row per unique source
    
    Relationships
    many:1 with source_types
    1:1 with applications
*/
SELECT
    /* primary key */
    id

    /* foreign keys */
    , organization_id
    , source_type_id

    /* timestamps */
    , created_at::TIMESTAMPTZ AS created_at

    /* properties */
    , title

    /* booleans */
    , is_archived
FROM {{ source('stg', 'sources') }}
