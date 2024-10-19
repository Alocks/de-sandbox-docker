# debezium-strimzi

This sample demonstrates a debezium connector for postgresql running in kafka with a complete CI/CD infrastucture.

## Deploy project
```bash
$ docker compose up -d # -d to run in background
```
## Keep running after logout
```bash
$ tmux # Starts tmux session
$ tmux list-sessions # List Sessions
$ tmux attach -t {session_name}
# To exit sessions you can ctrl+b d, or juse terminate the SSH session.
```

## Setup variables for compose.yml
```bash
# Varibles necesssary for postgres
$ export POSTGRES_USER={USERNAME}
$ export POSTGRES_PASSWORD={PASSWORD}
# Varibles necesssary for pgadmin4
$ export PGADMIN_USER={EMAIL}
$ export PGADMIN_PASSWORD={PASSWORD}
```

## Serialize the json file with env vars
```bash
$ jq '.' /debezium/postgres-teste.json | sed -e 's/$POSTGRES_USER/'"$POSTGRES_USER"'/g' -e 's/$POSTGRES_PASSWORD/'"$POSTGRES_PASSWORD"'/g'
```

## Check database container
```bash
$ docker compose exec postgres sh
root@c97c472db02e:/$ psql -U {USERNAME}
username=#
...