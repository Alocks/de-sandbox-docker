# Changelog
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
