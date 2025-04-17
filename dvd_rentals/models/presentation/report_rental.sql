{{
    config(
        materialized="table",
        unique_key = ["rental_id"]
    )
}}

select
{{ dbt_utils.star(from=ref('fact_rental'), relation_alias='fact_rental', except=[
        "film_key", "staff_key", "customer_key", "last_update"
    ]) }},
{{ dbt_utils.star(from=ref('dim_film'), relation_alias='dim_film', except=[
        "film_key", "staff_key", "customer_key", "last_update"
    ]) }},
{{ dbt_utils.star(from=ref('dim_customer'), relation_alias='dim_customer', except=[
        "customer_key", "address_key", "store_id", "last_update"
    ], prefix="CUSTOMER_") }},
{{ dbt_utils.star(from=ref('dim_address'), relation_alias='dim_address_customer', except=[
        "address_key", "last_update"
    ], prefix="CUSTOMER_") }},
{{ dbt_utils.star(from=ref('dim_staff'), relation_alias='dim_staff', except=[
        "staff_key", "address_key", "store_id", "last_update"
    ], prefix="STAFF_") }},
{{ dbt_utils.star(from=ref('dim_address'), relation_alias='dim_address_staff', except=[
        "address_key", "last_update"
    ], prefix="STAFF_") }},

from {{ ref('fact_rental') }} as fact_rental
left join {{ ref('dim_film') }} as dim_film on fact_rental.film_key = dim_film.film_key
left join {{ ref('dim_customer') }} as dim_customer on fact_rental.customer_key = dim_customer.customer_key
left join {{ ref('dim_address') }} as dim_address_customer on dim_customer.address_key = dim_address_customer.address_key
left join {{ ref('dim_staff') }} as dim_staff on fact_rental.staff_key = dim_staff.staff_key
left join {{ ref('dim_address') }} as dim_address_staff on dim_staff.address_key = dim_address_staff.address_key

