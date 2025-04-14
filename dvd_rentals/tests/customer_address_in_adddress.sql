select address_key from {{ ref("dim_customer")}}
where address_key NOT IN (SELECT address_key FROM {{ ref("dim_address" )}})
