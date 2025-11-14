IMPORT FOREIGN SCHEMA app
    LIMIT TO (
    regions,
    warehouses,
    suppliers,
    customers,
    product_categories,
    products,
    orders,
    order_items,
    inventory
    )
    FROM SERVER moldova_server
    INTO dwh_source;