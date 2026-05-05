{{ 
    config(
        materialized='view',
    )
}}

SELECT
    country_id,
	country,
	last_update
FROM {{ source('pagila', 'stg_country') }}