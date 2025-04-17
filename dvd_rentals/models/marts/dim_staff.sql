{{
    config(
        materialized="incremental",
        unique_key = ["staff_id"],
        incremental_strategy = "merge"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['st.staff_id']) }} as staff_key,
    st.staff_id,
    st.first_name,
    st.last_name,
    concat(st.first_name, ' ', st.last_name) as full_name,
    da.address_key,
    st.email,
    st.store_id,
    st.active::boolean as active,
    st.last_update,
from {{ source("db_staging", "staff")}} st
left join {{ ref("dim_address")}} da
    on st.address_id = da.address_id
{% if is_incremental() %}
    where st.last_update > (select max(staff.last_update) from {{ this }} as staff)
{% endif %}