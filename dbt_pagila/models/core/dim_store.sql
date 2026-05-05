{{
    config(
        materialized='table',
        unique_key='store_key'
    )
}}

WITH store_data AS (
    SELECT
        s.store_id,
		st.staff_id manager_staff_id,
		st.first_name manager_first_name,
		st.last_name manager_last_name,
		a.address,
		a.district,
		ci.city,
		co.country,
		a.postal_code,
		a.phone,
        COALESCE(s.last_update::DATE, CURRENT_DATE) as start_date,
        NULL as end_date,
        TRUE as is_current
    FROM {{ ref('stg_pagila__store') }} s
    LEFT JOIN {{ ref('stg_pagila__staff') }} st on s.manager_staff_id = st.staff_id 
    LEFT JOIN {{ ref('stg_pagila__address') }} a ON s.address_id = a.address_id  
    LEFT JOIN {{ ref('stg_pagila__city') }} ci ON a.city_id = ci.city_id
    LEFT JOIN {{ ref('stg_pagila__country') }} co ON ci.country_id = co.country_id
)

SELECT
    store_id as store_key,
    *
FROM store_data