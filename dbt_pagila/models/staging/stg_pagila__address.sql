{{ 
    config(
        materialized='view',
    )
}}

SELECT
    address_id,
	address,
	address2,
	district,
	city_id,
	postal_code,
	phone,
	last_update
FROM {{ source('pagila', 'stg_address') }}