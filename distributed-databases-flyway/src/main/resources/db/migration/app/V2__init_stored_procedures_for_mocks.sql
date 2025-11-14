SET search_path TO app;

-- ============================
-- PROCEDURE: insert_regions(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_regions(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    countries     TEXT[] := ARRAY ['Moldova', 'Bulgaria', 'Romania'];
    country_index INT;
BEGIN
    FOR i IN 1..cnt
        LOOP
            country_index := ((i - 1) % array_length(countries, 1)) + 1;

            INSERT INTO regions(region_name, country, region_code, description, is_active)
            VALUES ('Region ' || i,
                    countries[country_index],
                    'R' || LPAD(i::text, 3, '0'),
                    'Auto-generated region ' || i,
                    TRUE);
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_warehouses(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_warehouses(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    reg_count INT;
BEGIN
    SELECT COUNT(*) INTO reg_count FROM regions;

    IF reg_count = 0 THEN
        RAISE EXCEPTION 'Cannot insert warehouses: no regions exist.';
    END IF;

    FOR i IN 1..cnt
        LOOP
            INSERT INTO warehouses(warehouse_name, region_id, address, capacity, manager_name, contact_phone, is_active)
            VALUES ('Warehouse ' || i,
                    (SELECT region_id FROM regions ORDER BY random() LIMIT 1),
                    'Warehouse Street ' || i,
                    (random() * 500 + 50)::DECIMAL(10, 2),
                    'Manager ' || i,
                    '+3736000' || LPAD(i::text, 3, '0'),
                    TRUE);
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_suppliers(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_suppliers(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    reg_count INT;
BEGIN
    SELECT COUNT(*) INTO reg_count FROM regions;
    IF reg_count = 0 THEN
        RAISE EXCEPTION 'Cannot insert suppliers: no regions exist.';
    END IF;

    FOR i IN 1..cnt
        LOOP
            INSERT INTO suppliers(supplier_name, contact_person, email, phone, address, region_id,
                                  contract_number, contract_date, rating, is_active)
            VALUES ('Supplier ' || i,
                    'Person ' || i,
                    'supplier' || i || '@mail.com',
                    '+3736111' || LPAD(i::text, 3, '0'),
                    'Address ' || i,
                    (SELECT region_id FROM regions ORDER BY random() LIMIT 1),
                    'CN' || LPAD(i::text, 4, '0'),
                    CURRENT_DATE - (random() * 500)::INT,
                    (random() * 4 + 1)::DECIMAL(3, 2),
                    TRUE);
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_customers(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_customers(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    reg_count INT;
BEGIN
    SELECT COUNT(*) INTO reg_count FROM regions;
    IF reg_count = 0 THEN
        RAISE EXCEPTION 'Cannot insert customers: no regions exist.';
    END IF;

    FOR i IN 1..cnt
        LOOP
            INSERT INTO customers(customer_name, customer_type, contact_person, email, phone, address,
                                  region_id, registration_date, discount_percent, is_active)
            VALUES ('Customer ' || i,
                    CASE WHEN random() > 0.5 THEN 'individual' ELSE 'company' END,
                    'Contact ' || i,
                    'customer' || i || '@mail.com',
                    '+3736222' || LPAD(i::text, 3, '0'),
                    'Address ' || i,
                    (SELECT region_id FROM regions ORDER BY random() LIMIT 1),
                    CURRENT_DATE - (random() * 300)::INT,
                    (random() * 10)::DECIMAL(5, 2),
                    TRUE);
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_product_categories(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_product_categories(cnt INT)
    LANGUAGE plpgsql AS
$$
BEGIN
    FOR i IN 1..cnt
        LOOP
            INSERT INTO product_categories(category_name, description, parent_category_id, is_active)
            VALUES ('Category ' || i,
                    'Auto category ' || i,
                    NULL,
                    TRUE);
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_products(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_products(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    cat_count INT;
BEGIN
    SELECT COUNT(*) INTO cat_count FROM product_categories;
    IF cat_count = 0 THEN
        RAISE EXCEPTION 'Cannot insert products: no product categories exist.';
    END IF;

    FOR i IN 1..cnt
        LOOP
            INSERT INTO products(product_name, category_id, sku, description, weight, volume,
                                 unit_price, minimum_stock, is_active)
            VALUES ('Product ' || i,
                    (SELECT category_id FROM product_categories ORDER BY random() LIMIT 1),
                    'SKU-' || LPAD(i::text, 5, '0'),
                    'Auto generated product ' || i,
                    (random() * 10)::DECIMAL(10, 2),
                    (random() * 2)::DECIMAL(10, 2),
                    (random() * 100 + 10)::DECIMAL(10, 2),
                    (random() * 20)::INT,
                    TRUE);
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_orders(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_orders(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    cust_count INT;
    reg_count  INT;
BEGIN
    SELECT COUNT(*) INTO cust_count FROM customers;
    SELECT COUNT(*) INTO reg_count FROM regions;

    IF cust_count = 0 THEN
        RAISE EXCEPTION 'Cannot insert orders: no customers.';
    END IF;

    FOR i IN 1..cnt
        LOOP
            INSERT INTO orders(customer_id, required_delivery_date, status, shipping_address,
                               shipping_region_id, total_amount, payment_method, payment_status, notes)
            VALUES ((SELECT customer_id FROM customers ORDER BY random() LIMIT 1),
                    CURRENT_DATE + ((random() * 10)::INT),
                    'new',
                    'Shipping address ' || i,
                    (SELECT region_id FROM regions ORDER BY random() LIMIT 1),
                    (random() * 500 + 50)::DECIMAL(12, 2),
                    'card',
                    'pending',
                    'Order note ' || i);
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_order_items(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_order_items(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    ord_count  INT;
    prod_count INT;
BEGIN
    SELECT COUNT(*) INTO ord_count FROM orders;
    SELECT COUNT(*) INTO prod_count FROM products;

    IF ord_count = 0 THEN
        RAISE EXCEPTION 'Cannot insert order items: no orders.';
    END IF;

    FOR i IN 1..cnt
        LOOP
            INSERT INTO order_items(order_id, product_id, quantity, unit_price,
                                    discount_percent, total_price, status)
            VALUES ((SELECT order_id FROM orders ORDER BY random() LIMIT 1),
                    (SELECT product_id FROM products ORDER BY random() LIMIT 1),
                    (random() * 5 + 1)::INT,
                    (random() * 100 + 10)::DECIMAL(10, 2),
                    (random() * 15)::DECIMAL(5, 2),
                    (random() * 200 + 20)::DECIMAL(12, 2),
                    'pending');
        END LOOP;
END;
$$;

-- ============================
-- PROCEDURE: insert_inventory(count)
-- ============================
CREATE OR REPLACE PROCEDURE insert_inventory(cnt INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    wh_count   INT;
    prod_count INT;
BEGIN
    SELECT COUNT(*) INTO wh_count FROM warehouses;
    SELECT COUNT(*) INTO prod_count FROM products;

    IF wh_count = 0 OR prod_count = 0 THEN
        RAISE EXCEPTION 'Cannot insert inventory: missing warehouses or products.';
    END IF;

    FOR i IN 1..cnt
        LOOP
            INSERT INTO inventory(warehouse_id, product_id, quantity_available, quantity_reserved,
                                  last_restock_date, reorder_level)
            VALUES ((SELECT warehouse_id FROM warehouses ORDER BY random() LIMIT 1),
                    (SELECT product_id FROM products ORDER BY random() LIMIT 1),
                    (random() * 200)::INT,
                    (random() * 30)::INT,
                    CURRENT_TIMESTAMP - (random() * 50)::INT * INTERVAL '1 day',
                    (random() * 20)::INT)
            ON CONFLICT DO NOTHING;
        END LOOP;
END;
$$;
