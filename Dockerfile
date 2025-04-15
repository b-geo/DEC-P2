FROM python:3.10-slim

WORKDIR /usr/app

COPY . .
WORKDIR /usr/app/dvd_rentals
COPY ./dvd_rentals/profiles.yml /root/.dbt/profiles.yml
RUN pip install --upgrade pip
RUN pip install dbt-core
RUN pip install dbt-snowflake
RUN dbt clean --profiles-dir /usr/app/dvd_rentals
RUN dbt deps
RUN dbt compile --profiles-dir /usr/app/dvd_rentals


CMD ["dbt", "run"]
