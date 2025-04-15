{{
    config(
        materialized="table",
        unique_key="rental_id"
    )
}}

with pay_agg as (
select
    rental_key,
    sum(amount) as rental_amount,
    count(*) as number_of_payments,
from {{ ref("fact_payment")}} 
group by rental_key
)
select
    {{ dbt_utils.generate_surrogate_key(['re.rental_id']) }} as rental_key,
    re.rental_id,
    fp.rental_amount,
    fp.number_of_payments,
    DATE(re.rental_date) as rental_date,
    DATE(re.return_date) as return_date,
    fi.film_key,
    inv.store_id,
    st.staff_key
from {{ source("db_staging", "rental")}} re
left join {{ ref("dim_inventory")}} inv
    on {{ dbt_utils.generate_surrogate_key(['re.inventory_id']) }} = inv.inventory_key
left join {{ ref("dim_film")}} fi
    on inv.film_key = fi.film_key
left join {{ ref("dim_customer")}} cu
    on {{ dbt_utils.generate_surrogate_key(['re.customer_id']) }} = cu.customer_key
left join {{ ref("dim_staff")}} st
    on {{ dbt_utils.generate_surrogate_key(['re.staff_id']) }} = st.staff_key
left join pay_agg fp
    on {{ dbt_utils.generate_surrogate_key(['re.rental_id']) }} = fp.rental_key


