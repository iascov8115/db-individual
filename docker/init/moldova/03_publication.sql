-- роль для logical replication
CREATE ROLE replicator WITH LOGIN REPLICATION PASSWORD 'replicator_pass';

-- даём replicator'у право читать справочники
GRANT SELECT ON TABLE
    regions,
    product_categories,
    products
    TO replicator;

-- если планируешь вставки с identity/serial, полезно также:
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO replicator;

-- publication для справочников
CREATE PUBLICATION pub_reference_data
FOR TABLE
    regions,
    product_categories,
    products;
