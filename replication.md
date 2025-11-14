# Настройка репликации

```shell
docker compose down
```

```shell
docker volume rm -f \
  db-indiv_moldova_data \
  db-indiv_romania_data \
  db-indiv_bulgaria_data \
  db-indiv_moldova_replica_data \
  db-indiv_romania_replica_data \
  db-indiv_bulgaria_replica_data
```

```shell
docker compose up -d db_moldova && docker compose logs -f db_moldova
```

После запуска (`database system is ready to accept connections`) выходим из логов Ctrl+C

```shell
docker compose exec -it db_moldova bash -c "echo 'host replication replicator 0.0.0.0/0 md5' >> /var/lib/postgresql/data/pg_hba.conf"
```

```shell
docker compose down && docker compose up -d db_moldova db_romania db_bulgaria && docker compose logs -f db_bulgaria
```

После запуска (`logical replication table synchronization worker for subscription ... has finished`) выходим из логов Ctrl+C

```shell
docker compose exec -it db_romania bash -c "echo 'host replication replicator 0.0.0.0/0 md5' >> /var/lib/postgresql/data/pg_hba.conf"
```

```shell
docker compose exec -it db_bulgaria bash -c "echo 'host replication replicator 0.0.0.0/0 md5' >> /var/lib/postgresql/data/pg_hba.conf"
```

```shell
docker compose down && docker compose up -d
```