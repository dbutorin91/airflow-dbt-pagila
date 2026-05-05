{{
    config(
        materialized='table'
    )
}}

SELECT
    d.date_actual AS report_date,
    d.year_actual AS report_year,
    d.quarter_actual AS report_quarter,
    d.month_actual AS report_month,
    d.month_name, 
    f.rating,
    f.language,
    f.category,
    s.store_id,
    s.city,
    s.country,
    SUM(fr.amount) AS revenue,
    SUM(fr.count_rentals) AS rental_count,
    SUM(fr.amount) / SUM(fr.count_rentals) AS avg_rental_value,
    SUM(fr.rental_duration) AS total_rental_duration
FROM {{ ref('fact_rental') }} fr
JOIN {{ ref('dim_date') }} d ON fr.date_key = d.date_key
JOIN {{ ref('dim_film') }} f ON fr.film_key = f.film_key
JOIN {{ ref('dim_store') }} s ON fr.store_key = s.store_key
-- Фильтр по актуальным записям измерений
WHERE f.is_current = TRUE AND s.is_current = TRUE
GROUP BY
    d.date_actual,
    d.year_actual,
    d.quarter_actual,
    d.month_actual,
    d.month_name, 
    f.rating,
    f.language,
    f.category,
    s.store_id,
    s.city,
    s.country