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