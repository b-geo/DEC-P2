## Questions
- is it normal fact PLUS advanced fact or?
- cdc is a form of incremental, so i'm assuming we don't need an incremental query PLUS cdc?
- for the transformations, can they still be through dbt but to databricks? 

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