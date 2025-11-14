#!/usr/bin/env bash
set -e

: "${PGDATA:=/var/lib/postgresql/data}"

ROLE="${PGROLE:-primary}"          # primary / replica
PRIMARY_HOST="${PRIMARY_HOST:-}"   # host primary (для реплик)
REPL_USER="${REPL_USER:-replicator}"
REPL_PASSWORD="${REPL_PASSWORD:-replicator_pass}"

if [ "$ROLE" = "primary" ]; then
  echo "Starting as PRIMARY"

  exec docker-entrypoint.sh postgres \
    -c wal_level=logical \
    -c max_wal_senders=10 \
    -c max_replication_slots=10 \
    -c hot_standby=on

elif [ "$ROLE" = "replica" ]; then
  echo "Starting as REPLICA, primary = $PRIMARY_HOST"

  if [ -z "$PRIMARY_HOST" ]; then
    echo "ERROR: PRIMARY_HOST is not set for replica"
    exit 1
  fi

  if [ ! -s "$PGDATA/PG_VERSION" ]; then
    echo "PGDATA is empty, running basebackup from primary..."

    mkdir -p "$PGDATA"
    chown -R postgres:postgres "$PGDATA"

    su - postgres -c "
      PGPASSWORD='$REPL_PASSWORD' pg_basebackup \
        -h '$PRIMARY_HOST' \
        -U '$REPL_USER' \
        -D '$PGDATA' \
        -Fp \
        -Xs \
        -P \
        -R
    "
  else
    echo "PGDATA already initialized, skipping basebackup"
  fi

  exec docker-entrypoint.sh postgres \
    -c hot_standby=on

else
  echo "Unknown PGROLE: $ROLE (expected primary or replica)"
  exit 1
fi
