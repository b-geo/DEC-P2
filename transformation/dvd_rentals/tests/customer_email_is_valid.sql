select email from {{ ref("dim_customer")}}
where email not regexp('^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$')