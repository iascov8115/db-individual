CREATE OR REPLACE PROCEDURE dwh.sync_regions()
    LANGUAGE plpgsql
AS
$$
BEGIN
    --------------------------------------------------------------------
    -- 1. Вставка новых записей (ID, которых нет в DWH)
    --------------------------------------------------------------------
    INSERT INTO dwh.regions_hist (region_id, region_name, country, region_code, description)
    SELECT src.region_id,
           src.region_name,
           src.country,
           src.region_code,
           src.description
    FROM dwh_source.regions src
             LEFT JOIN dwh.regions_hist hist
                       ON hist.region_id = src.region_id AND hist.is_active = TRUE
    WHERE hist.region_id IS NULL;
    -- отсутствует активная версия


    --------------------------------------------------------------------
    -- 2. Вставка обновлённых записей (значения изменились)
    --------------------------------------------------------------------
    INSERT INTO dwh.regions_hist (region_id, region_name, country, region_code, description)
    SELECT src.region_id,
           src.region_name,
           src.country,
           src.region_code,
           src.description
    FROM dwh_source.regions src
             JOIN dwh.regions_hist hist
                  ON hist.region_id = src.region_id AND hist.is_active = TRUE
    WHERE (src.region_name, src.country, src.region_code, src.description) IS DISTINCT FROM (hist.region_name,
                                                                                             hist.country,
                                                                                             hist.region_code,
                                                                                             hist.description);

    --------------------------------------------------------------------
    -- 3. Деактивация старых версий при обновлении
    --------------------------------------------------------------------
    UPDATE dwh.regions_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    FROM dwh_source.regions src
    WHERE hist.region_id = src.region_id
      AND hist.is_active = TRUE
      AND (src.region_name, src.country, src.region_code, src.description) IS DISTINCT FROM (hist.region_name,
                                                                                             hist.country,
                                                                                             hist.region_code,
                                                                                             hist.description);

    --------------------------------------------------------------------
    -- 4. Деактивация записей, которые исчезли из источника
    --------------------------------------------------------------------
    UPDATE dwh.regions_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    WHERE hist.is_active = TRUE
      AND NOT EXISTS (SELECT 1
                      FROM dwh_source.regions src
                      WHERE src.region_id = hist.region_id);
END;
$$;


CREATE OR REPLACE PROCEDURE dwh.sync_orders()
    LANGUAGE plpgsql
AS
$$
BEGIN
    --------------------------------------------------------------------
    -- 1. Insert NEW orders
    --------------------------------------------------------------------
    INSERT INTO dwh.orders_hist (order_id, customer_id, order_date, required_delivery_date, status,
                                 shipping_address, shipping_region_id, total_amount, payment_method,
                                 payment_status, notes)
    SELECT src.order_id,
           src.customer_id,
           src.order_date,
           src.required_delivery_date,
           src.status,
           src.shipping_address,
           src.shipping_region_id,
           src.total_amount,
           src.payment_method,
           src.payment_status,
           src.notes
    FROM dwh_source.orders src
             LEFT JOIN dwh.orders_hist hist
                       ON hist.order_id = src.order_id AND hist.is_active = TRUE
    WHERE hist.order_id IS NULL;


    --------------------------------------------------------------------
    -- 2. Insert UPDATED orders (values differ)
    --------------------------------------------------------------------
    INSERT INTO dwh.orders_hist (order_id, customer_id, order_date, required_delivery_date, status,
                                 shipping_address, shipping_region_id, total_amount, payment_method,
                                 payment_status, notes)
    SELECT src.order_id,
           src.customer_id,
           src.order_date,
           src.required_delivery_date,
           src.status,
           src.shipping_address,
           src.shipping_region_id,
           src.total_amount,
           src.payment_method,
           src.payment_status,
           src.notes
    FROM dwh_source.orders src
             JOIN dwh.orders_hist hist
                  ON hist.order_id = src.order_id AND hist.is_active = TRUE
    WHERE (src.customer_id, src.order_date, src.required_delivery_date, src.status,
           src.shipping_address, src.shipping_region_id, src.total_amount,
           src.payment_method, src.payment_status, src.notes) IS DISTINCT FROM (hist.customer_id, hist.order_date,
                                                                                hist.required_delivery_date,
                                                                                hist.status,
                                                                                hist.shipping_address,
                                                                                hist.shipping_region_id,
                                                                                hist.total_amount,
                                                                                hist.payment_method,
                                                                                hist.payment_status, hist.notes);


    --------------------------------------------------------------------
    -- 3. Deactivate outdated versions
    --------------------------------------------------------------------
    UPDATE dwh.orders_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    FROM dwh_source.orders src
    WHERE hist.order_id = src.order_id
      AND hist.is_active = TRUE
      AND (src.customer_id, src.order_date, src.required_delivery_date, src.status,
           src.shipping_address, src.shipping_region_id, src.total_amount,
           src.payment_method, src.payment_status, src.notes) IS DISTINCT FROM (hist.customer_id, hist.order_date,
                                                                                hist.required_delivery_date,
                                                                                hist.status,
                                                                                hist.shipping_address,
                                                                                hist.shipping_region_id,
                                                                                hist.total_amount,
                                                                                hist.payment_method,
                                                                                hist.payment_status, hist.notes);


    --------------------------------------------------------------------
    -- 4. Deactivate deleted orders
    --------------------------------------------------------------------
    UPDATE dwh.orders_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    WHERE hist.is_active = TRUE
      AND NOT EXISTS (SELECT 1
                      FROM dwh_source.orders src
                      WHERE src.order_id = hist.order_id);
END;
$$;

CREATE OR REPLACE PROCEDURE dwh.sync_order_items()
    LANGUAGE plpgsql
AS
$$
BEGIN
    --------------------------------------------------------------------
    -- 1. Insert new rows
    --------------------------------------------------------------------
    INSERT INTO dwh.order_items_hist (order_item_id, order_id, product_id, quantity,
                                      unit_price, discount_percent, total_price, status)
    SELECT src.order_item_id,
           src.order_id,
           src.product_id,
           src.quantity,
           src.unit_price,
           src.discount_percent,
           src.total_price,
           src.status
    FROM dwh_source.order_items src
             LEFT JOIN dwh.order_items_hist hist
                       ON hist.order_item_id = src.order_item_id AND hist.is_active = TRUE
    WHERE hist.order_item_id IS NULL;


    --------------------------------------------------------------------
    -- 2. Insert updated rows
    --------------------------------------------------------------------
    INSERT INTO dwh.order_items_hist (order_item_id, order_id, product_id, quantity,
                                      unit_price, discount_percent, total_price, status)
    SELECT src.order_item_id,
           src.order_id,
           src.product_id,
           src.quantity,
           src.unit_price,
           src.discount_percent,
           src.total_price,
           src.status
    FROM dwh_source.order_items src
             JOIN dwh.order_items_hist hist
                  ON hist.order_item_id = src.order_item_id AND hist.is_active = TRUE
    WHERE (src.product_id, src.quantity, src.unit_price,
           src.discount_percent, src.total_price, src.status) IS DISTINCT FROM (hist.product_id, hist.quantity,
                                                                                hist.unit_price,
                                                                                hist.discount_percent, hist.total_price,
                                                                                hist.status);


    --------------------------------------------------------------------
    -- 3. Deactivate outdated
    --------------------------------------------------------------------
    UPDATE dwh.order_items_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    FROM dwh_source.order_items src
    WHERE hist.order_item_id = src.order_item_id
      AND hist.is_active = TRUE
      AND (src.product_id, src.quantity, src.unit_price,
           src.discount_percent, src.total_price, src.status) IS DISTINCT FROM (hist.product_id, hist.quantity,
                                                                                hist.unit_price,
                                                                                hist.discount_percent, hist.total_price,
                                                                                hist.status);


    --------------------------------------------------------------------
    -- 4. Deactivate deleted items
    --------------------------------------------------------------------
    UPDATE dwh.order_items_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    WHERE hist.is_active = TRUE
      AND NOT EXISTS (SELECT 1
                      FROM dwh_source.order_items src
                      WHERE src.order_item_id = hist.order_item_id);
END;
$$;

CREATE OR REPLACE PROCEDURE dwh.sync_all()
    LANGUAGE plpgsql
AS
$$
BEGIN
    CALL dwh.sync_regions();
    CALL dwh.sync_orders();
    CALL dwh.sync_order_items();
END;
$$;
