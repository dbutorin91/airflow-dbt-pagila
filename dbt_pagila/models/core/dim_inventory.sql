{{
    config(
        materialized='table'
    )
}}

WITH inventory_data AS (
    SELECT
        f.inventory_id,
		f.film_id,
		f.store_id,
        COALESCE(f.last_update::DATE, CURRENT_DATE) as start_date,
        NULL as end_date,
        TRUE as is_current
    FROM {{ ref('stg_pagila__inventory') }} f
)

SELECT
    inventory_id as inventory_key,
    *
FROM inventory_data