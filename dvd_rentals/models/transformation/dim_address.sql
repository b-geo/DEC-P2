{{
    config(
        materialized="table",
        unique_key="address_id"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['ad.address_id']) }} as address_key,
    ad.address_id,
    ad.address,
    ad.address2,
    ad.district,
    ci.city as city_name,
    ad.postal_code,
    co.country as country_name,
    CASE 
        WHEN ad.address_id IN (SELECT address_id FROM {{ source("db_staging", "staff")}}) THEN 'STAFF'
        WHEN ad.address_id IN (SELECT address_id FROM {{ source("db_staging", "store")}}) THEN 'STORE'
        WHEN ad.address_id IN (SELECT address_id FROM {{ source("db_staging", "customer")}}) THEN 'CUSTOMER'
        ELSE NULL
    END AS address_type
from {{ source("db_staging", "address")}} ad
left join {{ source("db_staging", "city")}} ci
    on ad.city_id = ci.city_id
left join {{ source("db_staging", "country")}} co
    on ci.country_id = co.country_id
