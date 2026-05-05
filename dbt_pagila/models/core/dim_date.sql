{{
    config(
        materialized='table',
        unique_key='date_key'
    )
}}

WITH date_data AS (
    select
	TO_CHAR(date_actual, 'YYYYMMDD')::INTEGER as date_key,
    date_actual,
    EXTRACT(ISODOW FROM date_actual) as day_of_week,
    CASE EXTRACT(ISODOW FROM date_actual)
        WHEN 1 THEN 'Понедельник'
        WHEN 2 THEN 'Вторник'
        WHEN 3 THEN 'Среда'
        WHEN 4 THEN 'Четверг'
        WHEN 5 THEN 'Пятница'
        WHEN 6 THEN 'Суббота'
        WHEN 7 THEN 'Воскресенье'
    END as day_name,
    EXTRACT(DAY FROM date_actual) as day_of_month,
    EXTRACT(MONTH FROM date_actual) as month_actual,
    CASE EXTRACT(MONTH FROM date_actual)
        WHEN 1 THEN 'Январь'
        WHEN 2 THEN 'Февраль'
        WHEN 3 THEN 'Март'
        WHEN 4 THEN 'Апрель'
        WHEN 5 THEN 'Май'
        WHEN 6 THEN 'Июнь'
        WHEN 7 THEN 'Июль'
        WHEN 8 THEN 'Август'
        WHEN 9 THEN 'Сентябрь'
        WHEN 10 THEN 'Октябрь'
        WHEN 11 THEN 'Ноябрь'
        WHEN 12 THEN 'Декабрь'
    END as month_name,
    EXTRACT(YEAR FROM date_actual) as year_actual,
    EXTRACT(QUARTER FROM date_actual) as quarter_actual
FROM 
    generate_series(
        '2000-01-01'::date,
        '2030-12-31'::date,
        '1 day'::interval
    ) as date_actual
)

SELECT
    *
FROM date_data