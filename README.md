# debezium-strimzi

This sample demonstrates a debezium connector for postgresql running in kafka with a complete CI/CD infrastucture.


## Deploy with docker compose

```bash
$ docker compose up -d
```


## Expected result

```bash
$ docker compose ps
```

## Check database container

```bash
$ docker compose exec db /bin/bash 
root@c97c472db02e:/# psql -U {USERNAME} dataset_x
dataset_x=#
... ...
```
