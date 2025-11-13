CREATE
    EXTENSION IF NOT EXISTS postgres_fdw;
-- соединение с db_slave1
CREATE
    SERVER shard_romania_srv
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_romania', dbname 'postgres', port '5432');

-- соединение с db_slave2
CREATE
    SERVER shard_bulgaria_srv
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_bulgaria', dbname 'postgres', port '5432');

-- маппинг пользователя (пароли свои)
CREATE
    USER MAPPING FOR appuser
    SERVER shard_romania_srv
    OPTIONS (user 'admin', password 'admin');

CREATE
    USER MAPPING FOR appuser
    SERVER shard_bulgaria_srv
    OPTIONS (user 'admin', password 'admin');

-- shard1: допустим, тут будут “восточные” регионы
CREATE
    FOREIGN TABLE orders_romania (
    order_id INTEGER,
    customer_id INT,
    order_date TIMESTAMP,
    required_delivery_date DATE,
    status VARCHAR(20),
    shipping_address TEXT,
    shipping_region_id INT,
    total_amount DECIMAL(12, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    notes TEXT
    )
    SERVER shard_romania_srv
    OPTIONS (schema_name 'public', table_name 'orders');


-- shard2: “западные” регионы
CREATE
    FOREIGN TABLE orders_bulgaria (
    order_id INTEGER,
    customer_id INT,
    order_date TIMESTAMP,
    required_delivery_date DATE,
    status VARCHAR(20),
    shipping_address TEXT,
    shipping_region_id INT,
    total_amount DECIMAL(12, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    notes TEXT
    )
    SERVER shard_bulgaria_srv
    OPTIONS (schema_name 'public', table_name 'orders');


CREATE VIEW orders_router AS
SELECT *
FROM orders
UNION ALL
SELECT *
FROM orders_romania
UNION ALL
SELECT *
FROM orders_bulgaria;


CREATE OR REPLACE FUNCTION route_orders_by_country()
    RETURNS trigger
    LANGUAGE plpgsql
AS $$
DECLARE
    v_country regions.country%TYPE;
    inserted_row orders%ROWTYPE; -- тип совпадает с view и локальной таблицей
BEGIN
    -- Определяем страну по региону
    SELECT country
    INTO v_country
    FROM regions
    WHERE region_id = NEW.shipping_region_id;

    IF v_country IS NULL THEN
        RAISE EXCEPTION 'Не найден регион id=% для заказа', NEW.shipping_region_id;
    END IF;

    -- ВАЖНО:
    -- order_id SERIAL, поэтому мы не указываем его в списке колонок,
    -- даём БД самой сгенерировать значение (и локально, и на шардах).

    IF v_country = 'Romania' THEN
        INSERT INTO orders_romania (
            customer_id,
            order_date,
            required_delivery_date,
            status,
            shipping_address,
            shipping_region_id,
            total_amount,
            payment_method,
            payment_status,
            notes
        )
        VALUES (
                   NEW.customer_id,
                   COALESCE(NEW.order_date, CURRENT_TIMESTAMP),
                   NEW.required_delivery_date,
                   COALESCE(NEW.status, 'new'),
                   NEW.shipping_address,
                   NEW.shipping_region_id,
                   NEW.total_amount,
                   NEW.payment_method,
                   COALESCE(NEW.payment_status, 'pending'),
                   NEW.notes
               )
        RETURNING * INTO inserted_row;

    ELSIF v_country = 'Bulgaria' THEN
        INSERT INTO orders_bulgaria (
            customer_id,
            order_date,
            required_delivery_date,
            status,
            shipping_address,
            shipping_region_id,
            total_amount,
            payment_method,
            payment_status,
            notes
        )
        VALUES (
                   NEW.customer_id,
                   COALESCE(NEW.order_date, CURRENT_TIMESTAMP),
                   NEW.required_delivery_date,
                   COALESCE(NEW.status, 'new'),
                   NEW.shipping_address,
                   NEW.shipping_region_id,
                   NEW.total_amount,
                   NEW.payment_method,
                   COALESCE(NEW.payment_status, 'pending'),
                   NEW.notes
               )
        RETURNING * INTO inserted_row;

    ELSE
        -- Все остальные страны идут в ЛОКАЛЬНУЮ таблицу orders
        INSERT INTO orders (
            customer_id,
            order_date,
            required_delivery_date,
            status,
            shipping_address,
            shipping_region_id,
            total_amount,
            payment_method,
            payment_status,
            notes
        )
        VALUES (
                   NEW.customer_id,
                   COALESCE(NEW.order_date, CURRENT_TIMESTAMP),
                   NEW.required_delivery_date,
                   COALESCE(NEW.status, 'new'),
                   NEW.shipping_address,
                   NEW.shipping_region_id,
                   NEW.total_amount,
                   NEW.payment_method,
                   COALESCE(NEW.payment_status, 'pending'),
                   NEW.notes
               )
        RETURNING * INTO inserted_row;
    END IF;

    RETURN inserted_row;
END;
$$;

CREATE TRIGGER trg_route_orders
    INSTEAD OF INSERT ON orders_router
    FOR EACH ROW
EXECUTE FUNCTION route_orders_by_country();

INSERT INTO orders_router (
    customer_id,
    required_delivery_date,
    shipping_address,
    shipping_region_id,
    total_amount,
    payment_method
) VALUES (
             1,
             '2025-11-20',
             'ул. Штефан чел Маре, 1',
             10,               -- region_id → country, например 'Romania'
             1500.00,
             'card'
         )
RETURNING *;