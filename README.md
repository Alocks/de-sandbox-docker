# de-sandbox-docker

Data engineer sandbox environment for developemnt and testing
* *Deployed Services*
 	* **Apache Spark**  <small>Unified analytics engine for large-scale data processing</small>
 	* **JupyterLab** <small>Web-server interactive development</small>
	* **Postgres** <small>SQL Database</small>
 	* **PgAdmin4** <small>Postgres Front-End for database administration</small>
    * **MySQL** <small>SQL Database</small>

## Services location
| Service    | location                  | 
|------------|---------------------------|
| postgres   | `localhost:5432`          |
| MySQL      | `localhost:3306`          |
| JupyterLab | `localhost:80/jupyterlab` |
| pgadmin4   | `localhost:80/pgadmin`    |


## Deploy project
1. *To deploy, first, to docker compose work properly, you need create a .env inside the root folder*
```bash
# Varibles necesssary for postgres
$ export POSTGRES_USER={USERNAME}
$ export POSTGRES_PASSWORD={PASSWORD}
$ export POSTGRES_PORT=5432
# Varibles necesssary for pgadmin4
$ export PGADMIN_USER={EMAIL}
$ export PGADMIN_PASSWORD={PASSWORD}
# Variables necessary for JupyterLab
$ export JSPARK_TOKEN={TOKEN}
# Variables necessary for nginx
$ export NGINX_PORT=80
```
2. *Run docker compose in shell*
```bash
$ docker compose up -d # -d to run in background
```
3. *Done!*  
> ***Tip:*** *If you wish to run even after logout, consider using tmux*
```bash
$ tmux # Starts tmux session
$ tmux list-sessions # List Sessions
$ tmux attach -t {session_name}
# To exit sessions you can ctrl+b d, or juse terminate the SSH session.
```  
# Project Notes
Notes for things that I may find helpful in the future.  
Hopefully I won't need... *~~Not so sure~~*
## Postgres
*Restore postgres backup*
```bash
$ pg_restore -U {POSTGRES_USER} -d dvdrental /var/lib/postgresql/backups/dvdrental.tar
```
*Check database container*
```bash
$ docker exec -it postgres-container sh
root@c97c472db02e:/$ psql -U {USERNAME}
username=#
```
## Debezium
*Serialize the json file with env vars*
```bash
$ jq '.' /debezium/postgres-teste.json | sed -e 's/$POSTGRES_USER/'"$POSTGRES_USER"'/g' -e 's/$POSTGRES_PASSWORD/'"$POSTGRES_PASSWORD"'/g'
```
