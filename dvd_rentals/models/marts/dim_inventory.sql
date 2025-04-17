{{
    config(
        materialized="incremental",
        unique_key = ["inventory_id"],
        incremental_strategy = "merge"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['inv.inventory_id']) }} as inventory_key, 
    inv.inventory_id,
    fi.film_key,
    inv.store_id,
    inv.last_update
from {{ source("db_staging", "inventory")}} inv
left join {{ ref("dim_film")}} fi
    on {{ dbt_utils.generate_surrogate_key(['inv.film_id']) }} = fi.film_key
{% if is_incremental() %}
    where inv.last_update > (select max(inventory.last_update) from {{ this }} as inventory)
{% endif %}