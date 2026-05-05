{{
    config(
        materialized='table',
        unique_key='rental_id'
    )
}}

WITH rental_payments AS (
    SELECT
        r.rental_id,
        r.rental_date,
        r.return_date,
        r.customer_id,
        r.staff_id,
        r.inventory_id,
        p.payment_id,
        p.amount,
        p.payment_date,
        EXTRACT(DAY FROM COALESCE(r.return_date, NOW()) - r.rental_date) as rental_duration
    FROM {{ ref('stg_pagila__rental') }} r
    JOIN {{ ref('stg_pagila__payment') }} p ON r.rental_id = p.rental_id
)
SELECT
    r.rental_id,
    TO_CHAR(r.rental_date, 'YYYYMMDD')::INTEGER as date_key,
    c.customer_key,
    s.staff_key,
    f.film_id as film_key,
    st.store_key,
    r.payment_id,
    r.rental_date,
    r.return_date,
    r.rental_duration,
    r.amount,
    1 as count_rentals
FROM rental_payments r
JOIN {{ ref('dim_customer') }} c ON r.customer_id = c.customer_id AND c.is_current
JOIN {{ ref('dim_staff') }} s ON r.staff_id = s.staff_id AND s.is_current
JOIN {{ ref('dim_inventory') }} f ON r.inventory_id = f.inventory_id AND f.is_current
JOIN {{ ref('dim_store') }} st ON f.store_id = st.store_id AND st.is_current