{{ 
    config(
        materialized='view',
    )
}}

SELECT
    rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update,
    -- Добавляем метаданные для инкрементальной загрузки
    rental_date as effective_date,
    NOW() as loaded_at
FROM {{ source('pagila', 'stg_rental') }}
WHERE rental_date >= '{{ var("load_start_date") }}'
