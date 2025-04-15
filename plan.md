## Questions
- can i hand in thursday?
- does slowly changing dimensions have to be from staging level or fine at end?

## PLAN
- rental from dvd rental, but do it as accumulating
    - return date would be null on first entry
    - last update can be used to bring accross new
    - DIM_CUSTOMER with full address as value
    - DIM_INVENTORY not needed
        - could be film and store on fact
    - DIM_STAFF with full address as value
    - DIM_STORE since store will be directly in the fact table vs using inventory
    - DIM_FILM
        - using film and film category
    - DIM_DATE

- posgres docker container
- schedule connection in airbyte docker container
- schedule for after dbt docker container


**db**
default:
  target: dev
  outputs:
    dev:
      type: databricks
      schema: default
      host: dbc-9bba6641-b690.cloud.databricks.com
      http_path: /sql/1.0/warehouses/ae104a4d64087499
      token: dapi181bdd8cb13d708b699f4599ff87b544

**steps done
- set up databricks and dbt together
- set up pogres source as docker
- from docket progres local to airbyte to databricks

# tomorrow
- technique or two on transformations
    - probably with the summary fact (snapshot fact)
- slowly changing dimensions for address, customer, film, staff
    - use valid from/to
- on big table like fact but all
- documentation for readme
- git branch and pull request
- inventory store id for rental table

- incremental WHERE MERGE
- one report for most recent year monthly - monthyl sales rolling average
- readme
- host
- one big table
- slowly changing dimensions