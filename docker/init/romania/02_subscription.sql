CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicator_pass';

CREATE
    SUBSCRIPTION romania_sub_reference_from_moldova
    CONNECTION 'host=db_moldova port=5432 dbname=postgres user=replicator password=replicator_pass'
    PUBLICATION pub_reference_data
    WITH (
        copy_data = true,
        enabled = true
        );