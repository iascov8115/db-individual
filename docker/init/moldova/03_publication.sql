-- роль для logical replication
CREATE ROLE replicator WITH LOGIN REPLICATION PASSWORD 'replicator_pass';

GRANT USAGE ON SCHEMA app TO replicator;

-- даём replicator'у право читать справочники
GRANT SELECT ON TABLE
    app.regions,
    app.product_categories,
    app.products
    TO replicator;

-- если планируешь вставки с identity/serial, полезно также:
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA app TO replicator;

-- publication для справочников
CREATE PUBLICATION pub_reference_data
FOR TABLE
    app.regions,
    app.product_categories,
    app.products;
