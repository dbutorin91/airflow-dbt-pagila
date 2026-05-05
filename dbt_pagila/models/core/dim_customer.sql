{{
    config(
        materialized='table',
        unique_key='customer_key'
    )
}}

WITH customer_data AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.active,
        a.address,
        a.district,
        ci.city,
        co.country,
        c.create_date as start_date,
        NULL as end_date,
        TRUE as is_current
    FROM {{ ref('stg_pagila__customer') }} c
    LEFT JOIN {{ ref('stg_pagila__address') }} a ON c.address_id = a.address_id
    LEFT JOIN {{ ref('stg_pagila__city') }} ci ON a.city_id = ci.city_id
    LEFT JOIN {{ ref('stg_pagila__country') }} co ON ci.country_id = co.country_id
)

SELECT
    customer_id as customer_key,
    *
FROM customer_data