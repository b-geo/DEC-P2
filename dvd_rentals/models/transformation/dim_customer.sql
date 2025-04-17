{{
    config(
        materialized="incremental",
        unique_key = ["customer_id"],
        incremental_strategy = "merge"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['cu.customer_id']) }} as customer_key, 
    cu.customer_id,
    cu.first_name,
    cu.last_name,
    concat(cu.first_name, ' ', cu.last_name) as full_name,
    cu.email,
    da.address_key,
    cu.store_id,
    cu.active::boolean as active,
    cu.last_update
from {{ source("db_staging", "customer")}} cu
left join {{ ref("dim_address")}} da
    on cu.address_id = da.address_id
{% if is_incremental() %}
    where cu.last_update > (select max(customer.last_update) from {{ this }} as customer)
{% endif %}