{{
    config(
        materialized="table",
        unique_key="payment_id"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['pa.payment_id']) }} as payment_key, 
    pa.payment_id,
    {{ dbt_utils.generate_surrogate_key(['pa.rental_id']) }} as rental_key,
    {{ dbt_utils.generate_surrogate_key(['pa.customer_id']) }} as customer_key,
    DATE(pa.payment_date) as payment_date,
    dd.quarter_of_year,
    {{ dbt_utils.generate_surrogate_key(['pa.staff_id']) }} as staff_key,
    pa.amount
from {{ source("db_staging", "payment")}} pa
left join {{ source("db_staging", "rental")}} re
    on pa.rental_id = re.rental_id
left join {{ ref("dim_date")}} dd
    on DATE(pa.payment_date) = dd.date_day