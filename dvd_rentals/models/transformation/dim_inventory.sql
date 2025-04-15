{{
    config(
        materialized="table",
        unique_key="inventory_id"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['inv.inventory_id']) }} as inventory_key, 
    inv.inventory_id,
    fi.film_key,
    inv.store_id
from {{ source("db_staging", "inventory")}} inv
left join {{ ref("dim_film")}} fi
    on {{ dbt_utils.generate_surrogate_key(['inv.film_id']) }} = fi.film_key