select replacement_cost from {{ ref("dim_film")}}
where replacement_cost < 0