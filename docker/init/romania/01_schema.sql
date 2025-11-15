CREATE SCHEMA app;

CREATE TABLE app.regions
(
    region_id   SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL,
    country     VARCHAR(100) NOT NULL,
    region_code VARCHAR(10)  NOT NULL UNIQUE,
    description TEXT,
    is_active   BOOLEAN DEFAULT TRUE
);

CREATE TABLE app.warehouses
(
    warehouse_id   SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(100)   NOT NULL,
    region_id      INT REFERENCES app.regions (region_id),
    address        TEXT           NOT NULL,
    capacity       DECIMAL(10, 2) NOT NULL, -- в кубических метрах
    manager_name   VARCHAR(100),
    contact_phone  VARCHAR(20),
    is_active      BOOLEAN DEFAULT TRUE
);

CREATE TABLE app.suppliers
(
    supplier_id     SERIAL PRIMARY KEY,
    supplier_name   VARCHAR(100) NOT NULL,
    contact_person  VARCHAR(100),
    email           VARCHAR(100),
    phone           VARCHAR(20),
    address         TEXT,
    region_id       INT REFERENCES app.regions (region_id),
    contract_number VARCHAR(50),
    contract_date   DATE,
    rating          DECIMAL(3, 2), -- рейтинг поставщика (1-5)
    is_active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE app.customers
(
    customer_id       SERIAL PRIMARY KEY,
    customer_name     VARCHAR(100) NOT NULL,
    customer_type     VARCHAR(20)  NOT NULL, -- физ. лицо, юр. лицо, и т.д.
    contact_person    VARCHAR(100),
    email             VARCHAR(100),
    phone             VARCHAR(20),
    address           TEXT,
    region_id         INT REFERENCES app.regions (region_id),
    registration_date DATE         NOT NULL DEFAULT CURRENT_DATE,
    discount_percent  DECIMAL(5, 2)         DEFAULT 0.00,
    is_active         BOOLEAN               DEFAULT TRUE
);

CREATE TABLE app.product_categories
(
    category_id        SERIAL PRIMARY KEY,
    category_name      VARCHAR(100) NOT NULL,
    description        TEXT,
    parent_category_id INT REFERENCES app.product_categories (category_id),
    is_active          BOOLEAN DEFAULT TRUE
);

CREATE TABLE app.products
(
    product_id    SERIAL PRIMARY KEY,
    product_name  VARCHAR(100)       NOT NULL,
    category_id   INT REFERENCES app.product_categories (category_id),
    sku           VARCHAR(50) UNIQUE NOT NULL,
    description   TEXT,
    weight        DECIMAL(10, 2), -- в кг
    volume        DECIMAL(10, 2), -- в куб. м.
    unit_price    DECIMAL(10, 2)     NOT NULL,
    minimum_stock INT     DEFAULT 0,
    is_active     BOOLEAN DEFAULT TRUE
);

CREATE TABLE app.orders
(
    order_id               SERIAL PRIMARY KEY,
    customer_id            INT REFERENCES app.customers (customer_id),
    order_date             TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    required_delivery_date DATE,
    status                 VARCHAR(20)    NOT NULL DEFAULT 'new',     -- новый, в обработке, отправлен, доставлен, отменен
    shipping_address       TEXT           NOT NULL,
    shipping_region_id     INT REFERENCES app.regions (region_id),
    total_amount           DECIMAL(12, 2) NOT NULL,
    payment_method         VARCHAR(50),
    payment_status         VARCHAR(20)             DEFAULT 'pending', -- ожидается, оплачен, возвращен
    notes                  TEXT
);

CREATE TABLE app.order_items
(
    order_item_id    SERIAL PRIMARY KEY,
    order_id         INT REFERENCES app.orders (order_id),
    product_id       INT REFERENCES app.products (product_id),
    quantity         INT            NOT NULL,
    unit_price       DECIMAL(10, 2) NOT NULL,
    discount_percent DECIMAL(5, 2)           DEFAULT 0.00,
    total_price      DECIMAL(12, 2) NOT NULL,                  -- цена с учетом количества и скидки
    status           VARCHAR(20)    NOT NULL DEFAULT 'pending' -- ожидается, готов к отправке, отправлен, доставлен
);

CREATE TABLE app.inventory
(
    inventory_id       SERIAL PRIMARY KEY,
    warehouse_id       INT REFERENCES app.warehouses (warehouse_id),
    product_id         INT REFERENCES app.products (product_id),
    quantity_available INT NOT NULL DEFAULT 0,
    quantity_reserved  INT NOT NULL DEFAULT 0,
    last_restock_date  TIMESTAMP,
    reorder_level      INT          DEFAULT 10,
    UNIQUE (warehouse_id, product_id)
);