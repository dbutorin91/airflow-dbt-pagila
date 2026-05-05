{{ 
    config(
        materialized='view',
    )
}}

SELECT
    city_id,
	city,
	country_id,
	last_update
FROM {{ source('pagila', 'stg_city') }}