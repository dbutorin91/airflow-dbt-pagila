{{ 
    config(
        materialized='view',
    )
}}

SELECT film_id, category_id, last_update
FROM {{ source('pagila', 'stg_film_category') }}
