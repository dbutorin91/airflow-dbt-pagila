{{ 
    config(
        materialized='view',
    )
}}

SELECT
    store_id,
	manager_staff_id,
	address_id,
	last_update
FROM {{ source('pagila', 'stg_store') }}
