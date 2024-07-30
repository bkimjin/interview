-- Assume there are 3 tables t00 , t01 and t02 under schema s0 in redshift. Table t00 has a col1 with data in the form of 
-- {"key_t00_0": "value", "key_t00_1": "<value>"}
-- , t01 has a col1 with a varchar type and t02 has a col1 with data in the form of
-- {"key_t02_0": "value", "key_t02_1": "<value>"} . We want to use dbt to materialise a table t10 under schema s1 , non-incrementally, 
-- such that a it contains those records where the <value> against key_t00_1 matches exactly the col1 in t01 and also matches the <value> 
-- against key_t02_0

-- s1.t0
-- ___
-- col1 : json key_0 key_1

-- s1.t1
-- ___
-- col1 : varchar

-- s1.t2
-- ___
-- col1 :json t0 t1

-- t10.sql


dbt-project.yml

models:
    output:
    +schema: 's1'

;;

directory
- t10.sql
- t11.sql
- schema_directory.yml

schema:
    + schema
    - name: t10


;;

{{ config[
    schema = 's1',
    prehook = {{this}}
    post_hook = {{this}}
]
}}
WITH t00 AS ()

, new_data AS (
SELECT count(*)
FROM {{ source('s0', 't00') }} as t00
INNER JOIN {{ source('s0', 't01')}} as t01 ON t00.a = t01.b
INNER JOIN {{ source('s0', 't02')}} as t02 ON t00.a = t02.b
)
existing_data AS (
SELECT count(*)
FROM {{ this }}
)


;;

select
    col1:key_t00_0 as key_t00_0
from {{ source('s1', 't00') }} as t00

;;;


-- We want to prevent the construction of a downstream model t20 under schema s2 which depends on t10 under s1 above, if after a fresh materialisation, the 
-- number of records in t10 is < 80% of records before the new materialisation.

s12

s10 -> 

dbt run -s +t10
dbt test -s +t10
dbt run -s t20
dbt test -s t20
dbt build

t00, t01, t02, t10, t20
unit tests of t00, t01, t02, t10, t20

schema.yml
    - name: t10
        - test:
            - if prehook is NULL:
                return
              else:
                

;;
select count(*)
from {{ this }}


;;

{ config =
    [prehook = {set prehook = select count(*) from {{this}}};
    post_hook = {
        select count(*) as new_count from {{this}} where prehook * .8 < new_count 
    }

    ]
}
