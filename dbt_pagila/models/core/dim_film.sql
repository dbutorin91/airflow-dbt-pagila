{{
    config(
        materialized='table'
    )
}}

WITH film_data AS (
    SELECT
        f.film_id,
		f.title,
		f.description,
		f.release_year,
		l.name as language,
		f.rental_duration,
		f.rental_rate,
		f.length,
		f.replacement_cost,
		f.rating,
		f.special_features,
		c.name category,
        COALESCE(f.last_update::DATE, CURRENT_DATE) as start_date,
        NULL as end_date,
        TRUE as is_current
    FROM {{ ref('stg_pagila__film') }} f
    LEFT JOIN {{ ref('stg_pagila__language') }} l ON f.language_id = l.language_id
    LEFT JOIN {{ ref('stg_pagila__film_category') }} fc ON fc.film_id = f.film_id
    LEFT JOIN {{ ref('stg_pagila__category') }} c ON c.category_id = fc.category_id
)

SELECT
    film_id as film_key,
    *
FROM film_data