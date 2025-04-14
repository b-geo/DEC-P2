{{
    config(
        materialized="table",
        unique_key="film_id"
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['fi.film_id']) }} as film_key,
    fi.film_id,
    fi.title,
    fi.release_year,
    ca.name as category,
    fi.description,
    la.name as language,
    fi.rental_duration,
    fi.length,
    fi.replacement_cost,
    fi.rating,
    fi.special_features
from {{ source("db_staging", "film")}} fi
left join {{ source("db_staging", "film_category")}} fc
    on fi.film_id = fc.film_id
left join {{ source("db_staging", "category")}} ca
    on fc.category_id = ca.category_id
left join {{ source("db_staging", "language")}} la
    on fi.language_id = la.language_id