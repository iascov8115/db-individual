SET search_path TO app;

CALL insert_regions(10);
CALL insert_warehouses(5);
CALL insert_suppliers(10);
CALL insert_customers(20);
CALL insert_product_categories(8);
CALL insert_products(50);
CALL insert_orders(30);
CALL insert_order_items(100);
CALL insert_inventory(80);