{{
    config(
        materialized="table",
        unique_key = ["store_id", "month_of_year", "year_number"]
    )
}}
with 
stores as (
    select distinct store_id 
    from {{ ref("fact_rental")}}
),

date_months as (
    select 
        month_of_year as month,
        year_number as year,
        min(date_day) as month_start_date
    from {{ ref("dim_date")}}
    where date_day >= (select max(last_update) from {{ ref("fact_rental")}}) - INTERVAL '1 year, 1 month'
      and date_day <= (select max(last_update) from {{ ref("fact_rental")}})
    group by month_of_year, year_number
),

store_months as (
    select 
        s.store_id,
        dm.month,
        dm.year,
        dm.month_start_date
    from stores s
    cross join date_months dm
)

select
    sum(fr.rental_amount) as revenue,
    sum(fr.rental_id) as number_of_sales,
    sm.store_id,
    sm.month,
    sm.year
from store_months sm
left join {{ ref("fact_rental")}} fr
    on sm.store_id = fr.store_id
    and fr.rental_date between sm.month_start_date 
        and (sm.month_start_date + INTERVAL '1 month' - INTERVAL '1 day')
group by sm.store_id, sm.year, sm.month
order by sm.year, sm.month, sm.store_id