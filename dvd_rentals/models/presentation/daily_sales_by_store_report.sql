{{
    config(
        materialized="table",
        unique_key = ["day_date"]
    )
}}
select
    sum(fr.rental_amount) as revenue,
    sum(fr.rental_id) as number_of_sales,
    fr.store_id,
    dd.date_day as date
from {{ ref("dim_date")}} dd 
left join {{ ref("fact_rental")}} fr
    on  dd.day_date = fr.rental_date
where dd.day_date > (select max(last_update) from {{ ref("fact_rental")}}) - INTERVAL '1 month'
