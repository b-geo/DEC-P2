{{
    config(
        materialized="incremental",
        unique_key = ["date_day"],
        incremental_strategy = "merge"
    )
}}
with dd as ({{ dbt_date.get_date_dimension(
        start_date="2004-01-01",
        end_date="2025-01-01"
)}})
select * from dd
{% if is_incremental() %}
    where dd.date_day not in (select date_day from {{ this }} )
{% endif %}
