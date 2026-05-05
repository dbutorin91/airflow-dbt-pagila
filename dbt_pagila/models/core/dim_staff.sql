{{
    config(
        materialized='table',
        unique_key='staff_key'
    )
}}

WITH staff_data AS (
    SELECT
        s.staff_id,
		s.first_name,
		s.last_name,
		s.email,
		s.active,
		s.store_id,
		s.username,
		a.address,
		a.district,
		ci.city,
		co.country,
		a.phone,
        COALESCE(s.last_update::DATE, CURRENT_DATE) as start_date,
        NULL as end_date,
        TRUE as is_current
    FROM {{ ref('stg_pagila__staff') }} s
    LEFT JOIN {{ ref('stg_pagila__address') }} a ON s.address_id = a.address_id  
    LEFT JOIN {{ ref('stg_pagila__city') }} ci ON a.city_id = ci.city_id
    LEFT JOIN {{ ref('stg_pagila__country') }} co ON ci.country_id = co.country_id
)

SELECT
    staff_id as staff_key,
    *
FROM staff_data