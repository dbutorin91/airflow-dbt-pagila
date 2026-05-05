{{ 
    config(
        materialized='view',
    )
}}

SELECT language_id, "name", last_update
FROM {{ source('pagila', 'stg_language') }}
