CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER moldova_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_moldova', port '5432', dbname 'postgres');

CREATE USER MAPPING FOR flyway
    SERVER moldova_server
    OPTIONS (user 'flyway', password 'flywayPass');