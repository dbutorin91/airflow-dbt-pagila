{{ 
    config(
        materialized='view',
    )
}}

SELECT
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date,
    -- Добавляем метаданные для инкрементальной загрузки
    payment_date as effective_date,
    NOW() as loaded_at
FROM {{ source('pagila', 'stg_payment') }}
WHERE payment_date >= '{{ var("load_start_date") }}'
