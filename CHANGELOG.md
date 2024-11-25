# Changelog
## Rev4 - 2024-11-24
- Changed from `Apache` license to `MIT`
- Add `nginx` to redirect services
- Redirected service `jupyterlab` (localhost:8888) to `localhost/jupyterlab`
- Redirected service `pgadmin` (localhost:5050) to `localhost/pgadmin`


## Rev3 - 2024-10-21
- add function tests for github actions
- create `build.sh` for easier build management
- refactor `compose.yml` and now use external volumes to data *always* persist
- `jspark` now starts with a custom `dockerfile` to add delta support mitigate some issues
- added `spark.sql.repl.eagerEval.enabled` in `pyspark` options to have a pretty print from the dataframe
- Refactor `ci-pipeline.yml` and scripts to make it more readable

## Rev2 - 2024-10-21
- create `jspark` service to run jupyterlab and spark seamslessly
- add `dvdrental` dump using local mount for sample database in postgres
- update `README.md`
- refactor folder and filenames strcuture
- create `script 00-create_spark_session.py` to automate spark session for jspark

## Rev1 - 2024-10-19
- Change `compose.yml` to have all services needed, but `debezium`, which is commented inside.
- Create `audit-compose-file.yml` for github actions on PR.
- Added a kafka conector for postgres server
- Add validation in the CI pipeline for debezium json files
