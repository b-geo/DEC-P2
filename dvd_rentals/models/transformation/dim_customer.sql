{{
    config(
        materialized="table",
        unique_key="customer_id"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['cu.customer_id']) }} as customer_key, 
    cu.customer_id,
    cu.first_name,
    cu.last_name,
    concat(cu.first_name, ', ', cu.last_name) as full_name,
    cu.email,
    da.address_key,
    cu.store_id,
    cu.active::boolean as active
from {{ source("db_staging", "customer")}} cu
left join {{ ref("dim_address")}} da
    on cu.address_id = da.address_id
