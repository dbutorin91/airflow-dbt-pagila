{{ 
    config(
        materialized='view',
    )
}}

SELECT
    staff_id, first_name, last_name, address_id, email, store_id, active, username, "password", last_update, picture
FROM {{ source('pagila', 'stg_staff') }}