-- роль replicator должна существовать на publisher (db_moldova),
-- здесь она не обязательна, можно подключаться как admin,
-- но для симметрии можно тоже создать:
CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicator_pass';

-- subscription: тянем справочники из db_moldova
CREATE
    SUBSCRIPTION bulgaria_sub_reference_from_moldova
    CONNECTION 'host=db_moldova port=5432 dbname=postgres user=replicator password=replicator_pass'
    PUBLICATION pub_reference_data
    WITH (
        copy_data = true,
        enabled = true
        );