{{
    config(
        materialized="table",
        unique_key = ["store_id", "month_of_year", "year_number"]
    )
}}
select
    sum(fr.rental_amount) as revenue,
    sum(fr.rental_id) as number_of_sales,
    fr.store_id,
    dd.month_of_year as month,
    dd.year_number as year
from {{ ref("dim_date")}} dd 
left join {{ ref("fact_rental")}} fr
    on  dd.date_day = fr.rental_date
where dd.date_day >= (select max(last_update) from {{ ref("fact_rental")}}) - INTERVAL '1 year, 1 month'
    and dd.date_day <= (select max(last_update) from {{ ref("fact_rental")}})
group by fr.store_id, dd.year_number, dd.month_of_year
order by dd.year_number, dd.month_of_year