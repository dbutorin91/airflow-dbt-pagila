{{ 
    config(
        materialized='view',
    )
}}

SELECT category_id, "name", last_update
FROM {{ source('pagila', 'stg_category') }}
