CREATE TABLE IF NOT EXISTS dwh.regions_hist
(
    region_hid  BIGSERIAL PRIMARY KEY,
    region_id   INT       NOT NULL,
    region_name VARCHAR(100),
    country     VARCHAR(100),
    region_code VARCHAR(10),
    description TEXT,

    valid_from  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to    TIMESTAMP,
    is_active   BOOLEAN   NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dwh.orders_hist
(
    order_hid              BIGSERIAL PRIMARY KEY,
    order_id               INT       NOT NULL,

    customer_id            INT,
    order_date             TIMESTAMP,
    required_delivery_date DATE,
    status                 VARCHAR(20),
    shipping_address       TEXT,
    shipping_region_id     INT,
    total_amount           DECIMAL(12, 2),
    payment_method         VARCHAR(50),
    payment_status         VARCHAR(20),
    notes                  TEXT,

    valid_from             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to               TIMESTAMP,
    is_active              BOOLEAN   NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dwh.order_items_hist
(
    order_item_hid   BIGSERIAL PRIMARY KEY,
    order_item_id    INT       NOT NULL,

    order_id         INT       NOT NULL,
    product_id       INT,
    quantity         INT,
    unit_price       DECIMAL(10, 2),
    discount_percent DECIMAL(5, 2),
    total_price      DECIMAL(12, 2),
    status           VARCHAR(20),

    valid_from       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to         TIMESTAMP,
    is_active        BOOLEAN   NOT NULL DEFAULT TRUE
);

