-- включаем FDW
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- сервера-шарды
CREATE SERVER shard_romania_srv
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_romania', dbname 'postgres', port '5432');

CREATE SERVER shard_bulgaria_srv
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_bulgaria', dbname 'postgres', port '5432');

-- юзер-маппинги
CREATE USER MAPPING FOR admin
    SERVER shard_romania_srv
    OPTIONS (user 'admin', password 'admin');

CREATE USER MAPPING FOR admin
    SERVER shard_bulgaria_srv
    OPTIONS (user 'admin', password 'admin');

DROP FOREIGN TABLE IF EXISTS app.orders_romania CASCADE;
DROP FOREIGN TABLE IF EXISTS app.write_orders_romania CASCADE;
DROP FOREIGN TABLE IF EXISTS app.orders_bulgaria CASCADE;
DROP FOREIGN TABLE IF EXISTS app.write_orders_bulgaria CASCADE;

CREATE FOREIGN TABLE app.orders_romania (
    order_id INT NOT NULL,
    customer_id INT,
    order_date TIMESTAMP NOT NULL,
    required_delivery_date DATE,
    status VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_region_id INT,
    total_amount DECIMAL(12, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    notes TEXT
    )
    SERVER shard_romania_srv
    OPTIONS (schema_name 'app', table_name 'orders');

CREATE FOREIGN TABLE app.orders_bulgaria (
    order_id INT NOT NULL,
    customer_id INT,
    order_date TIMESTAMP NOT NULL,
    required_delivery_date DATE,
    status VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_region_id INT,
    total_amount DECIMAL(12, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    notes TEXT
    )
    SERVER shard_bulgaria_srv
    OPTIONS (schema_name 'app', table_name 'orders');

CREATE FOREIGN TABLE app.write_orders_romania (
    customer_id INT,
    order_date TIMESTAMP NOT NULL,
    required_delivery_date DATE,
    status VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_region_id INT,
    total_amount DECIMAL(12, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    notes TEXT
    )
    SERVER shard_romania_srv
    OPTIONS (schema_name 'app', table_name 'orders');

CREATE FOREIGN TABLE app.write_orders_bulgaria (
    customer_id INT,
    order_date TIMESTAMP NOT NULL,
    required_delivery_date DATE,
    status VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    shipping_region_id INT,
    total_amount DECIMAL(12, 2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    notes TEXT
    )
    SERVER shard_bulgaria_srv
    OPTIONS (schema_name 'app', table_name 'orders');

-- общее представление
DROP TRIGGER IF EXISTS trg_route_orders ON app.orders_distributed;
DROP FUNCTION IF EXISTS app.route_orders_by_country();
DROP VIEW IF EXISTS app.orders_distributed;

CREATE VIEW app.orders_distributed AS
SELECT o.order_id,
       o.customer_id,
       o.order_date,
       o.required_delivery_date,
       o.status,
       o.shipping_address,
       o.shipping_region_id,
       o.total_amount,
       o.payment_method,
       o.payment_status,
       o.notes
FROM app.orders o
UNION ALL
SELECT r.order_id,
       r.customer_id,
       r.order_date,
       r.required_delivery_date,
       r.status,
       r.shipping_address,
       r.shipping_region_id,
       r.total_amount,
       r.payment_method,
       r.payment_status,
       r.notes
FROM app.orders_romania r
UNION ALL
SELECT b.order_id,
       b.customer_id,
       b.order_date,
       b.required_delivery_date,
       b.status,
       b.shipping_address,
       b.shipping_region_id,
       b.total_amount,
       b.payment_method,
       b.payment_status,
       b.notes
FROM app.orders_bulgaria b;



-- routing-функция: определяем страну по shipping_region_id
CREATE OR REPLACE FUNCTION app.route_orders_by_country()
    RETURNS trigger
    LANGUAGE plpgsql
AS
$$
DECLARE
    v_country app.regions.country%TYPE;
BEGIN
    SELECT country
    INTO v_country
    FROM app.regions
    WHERE region_id = NEW.shipping_region_id;

    IF v_country IS NULL THEN
        RAISE EXCEPTION 'Не найден регион id=% для заказа', NEW.shipping_region_id;
    END IF;

    IF v_country = 'Romania' THEN
        INSERT INTO app.write_orders_romania (customer_id,
                                              order_date,
                                              required_delivery_date,
                                              status,
                                              shipping_address,
                                              shipping_region_id,
                                              total_amount,
                                              payment_method,
                                              payment_status,
                                              notes)
        VALUES (NEW.customer_id,
                COALESCE(NEW.order_date, CURRENT_TIMESTAMP),
                NEW.required_delivery_date,
                COALESCE(NEW.status, 'new'),
                NEW.shipping_address,
                NEW.shipping_region_id,
                NEW.total_amount,
                NEW.payment_method,
                COALESCE(NEW.payment_status, 'pending'),
                NEW.notes);

    ELSIF v_country = 'Bulgaria' THEN
        INSERT INTO app.write_orders_bulgaria (customer_id,
                                               order_date,
                                               required_delivery_date,
                                               status,
                                               shipping_address,
                                               shipping_region_id,
                                               total_amount,
                                               payment_method,
                                               payment_status,
                                               notes)
        VALUES (NEW.customer_id,
                COALESCE(NEW.order_date, CURRENT_TIMESTAMP),
                NEW.required_delivery_date,
                COALESCE(NEW.status, 'new'),
                NEW.shipping_address,
                NEW.shipping_region_id,
                NEW.total_amount,
                NEW.payment_method,
                COALESCE(NEW.payment_status, 'pending'),
                NEW.notes);

    ELSE
        -- все остальные страны — в локальную таблицу orders (db_moldova)
        INSERT INTO app.orders (customer_id,
                                order_date,
                                required_delivery_date,
                                status,
                                shipping_address,
                                shipping_region_id,
                                total_amount,
                                payment_method,
                                payment_status,
                                notes)
        VALUES (NEW.customer_id,
                COALESCE(NEW.order_date, CURRENT_TIMESTAMP),
                NEW.required_delivery_date,
                COALESCE(NEW.status, 'new'),
                NEW.shipping_address,
                NEW.shipping_region_id,
                NEW.total_amount,
                NEW.payment_method,
                COALESCE(NEW.payment_status, 'pending'),
                NEW.notes);
    END IF;

    RETURN NULL;
END;
$$;


CREATE OR REPLACE TRIGGER trg_route_orders
    INSTEAD OF INSERT
    ON app.orders_distributed
    FOR EACH ROW
EXECUTE FUNCTION app.route_orders_by_country();