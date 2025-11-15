INSERT INTO app.regions (region_name, country, region_code, description, is_active)
VALUES
-- MOLDOVA
('Chișinău Municipality', 'Moldova', 'MD-CH', 'Capital region of Moldova', true),
('Bălți Municipality', 'Moldova', 'MD-BA', 'Northern administrative hub', true),
('Cahul District', 'Moldova', 'MD-CA', 'Southern region known for logistics centers', true),
('Orhei District', 'Moldova', 'MD-OR', 'Central district with agricultural industry', true),
('Ungheni District', 'Moldova', 'MOLD', 'Western district near Romania border', true),

-- ROMANIA
('Bucharest', 'Romania', 'RO-B', 'Capital city of Romania', true),
('Cluj County', 'Romania', 'RO-CJ', 'Major tech and industrial region', true),
('Timiș County', 'Romania', 'RO-TM', 'Western Romania logistics corridor', true),
('Iași County', 'Romania', 'RO-IS', 'Northeastern academic and transport hub', true),
('Constanța County', 'Romania', 'RO-CT', 'Black Sea port and maritime region', true),

-- BULGARIA
('Sofia City Province', 'Bulgaria', 'BG-SF', 'Capital province of Bulgaria', true),
('Plovdiv Province', 'Bulgaria', 'BG-PD', 'Major industrial and agricultural hub', true),
('Varna Province', 'Bulgaria', 'BG-VAR', 'Largest Black Sea port region', true),
('Burgas Province', 'Bulgaria', 'BG-BS', 'Southern Black Sea logistics node', true),
('Ruse Province', 'Bulgaria', 'BG-RS', 'Danube river crossing and transport hub', true);

-- ROOT CATEGORIES -------------------------------------------------------------

-- 1. Electronics
INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Electronics', 'All electronic devices and components', NULL, true);

-- 2. Home & Kitchen
INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Home & Kitchen', 'Household goods, appliances and kitchenware', NULL, true);

-- 3. Clothing & Accessories
INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Clothing & Accessories', 'Clothes, shoes, and fashion items', NULL, true);

-- 4. Food & Beverages
INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Food & Beverages', 'Groceries, packaged food and drinks', NULL, true);

-- 5. Automotive
INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Automotive', 'Car parts, tools, and accessories', NULL, true);


-- SUBCATEGORIES: Electronics ---------------------------------------------------

INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Phones & Smartphones', 'Mobile phones and smartphones', 1, true),
       ('Laptops', 'Portable computers and notebooks', 1, true),
       ('Computer Components', 'Hardware components for PCs and servers', 1, true),
       ('TV & Audio', 'Televisions, speakers, and audio equipment', 1, true);


-- SUBCATEGORIES: Phones --------------------------------------------------------

INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Android Phones', 'Phones based on Android OS', 6, true),
       ('iPhones', 'Apple iPhone devices', 6, true),
       ('Phone Accessories', 'Cases, chargers, cables, protectors', 6, true);


-- SUBCATEGORIES: Laptops -------------------------------------------------------

INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Gaming Laptops', 'High-performance laptops for gaming', 7, true),
       ('Business Laptops', 'Laptops for business and office use', 7, true),
       ('Laptop Accessories', 'Bags, docks, stands, power adapters', 7, true);


-- SUBCATEGORIES: Home & Kitchen ------------------------------------------------

INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Kitchen Appliances', 'Electric and mechanical kitchen appliances', 2, true),
       ('Home Appliances', 'Large household appliances', 2, true),
       ('Furniture', 'Home and office furniture', 2, true);


-- SUBCATEGORIES: Clothing -------------------------------------------------------

INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Men Clothing', 'Men’s wear', 3, true),
       ('Women Clothing', 'Women’s wear', 3, true),
       ('Kids Clothing', 'Children’s wear', 3, true);


-- SUBCATEGORIES: Food & Beverages ----------------------------------------------

INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Fresh Food', 'Perishable products: fruits, vegetables, meat', 4, true),
       ('Packaged Food', 'Snacks, cereals, canned food', 4, true),
       ('Drinks', 'Beverages, tea, coffee, juices', 4, true);


-- SUBCATEGORIES: Automotive -----------------------------------------------------

INSERT INTO product_categories (category_name, description, parent_category_id, is_active)
VALUES ('Oil & Fluids', 'Motor oils and other technical fluids', 5, true),
       ('Car Electronics', 'Radios, GPS, onboard computers', 5, true),
       ('Tools & Equipment', 'Repair tools, equipment, accessories', 5, true);

-- Electronics (1)
--  ├── Phones & Smartphones (6)
--  │    ├── Android Phones
--  │    ├── iPhones
--  │    └── Phone Accessories
--  ├── Laptops (7)
--  │    ├── Gaming Laptops
--  │    ├── Business Laptops
--  │    └── Laptop Accessories
--  ├── Computer Components
--  └── TV & Audio
-- 
-- Home & Kitchen (2)
--  ├── Kitchen Appliances
--  ├── Home Appliances
--  └── Furniture
-- 
-- Clothing & Accessories (3)
--  ├── Men Clothing
--  ├── Women Clothing
--  └── Kids Clothing
-- 
-- Food & Beverages (4)
--  ├── Fresh Food
--  ├── Packaged Food
--  └── Drinks
-- 
-- Automotive (5)
--  ├── Oil & Fluids
--  ├── Car Electronics
--  └── Tools & Equipment
-- 

INSERT INTO products
(product_name, category_id, sku, description, weight, volume, unit_price, minimum_stock, is_active)
VALUES ('Samsung Galaxy A54', 6, 'PHN-0001', 'Mid-range Android smartphone', 0.45, 0.0006, 350.00, 20, true),
       ('iPhone 14', 6, 'PHN-0002', 'Apple smartphone, latest generation', 0.43, 0.0005, 890.00, 15, true),
       ('Xiaomi Redmi Note 12', 6, 'PHN-0003', 'Affordable Android smartphone', 0.40, 0.0006, 220.00, 25, true),
       ('USB-C Charger 25W', 8, 'ACC-1001', 'Fast charging power adapter', 0.12, 0.0002, 19.90, 50, true),
       ('iPhone Lightning Cable 1m', 8, 'ACC-1002', 'Original Apple cable', 0.05, 0.0001, 25.00, 40, true),
       ('Tempered Glass Protector', 8, 'ACC-1003', 'Screen protector for smartphones', 0.03, 0.00015, 7.50, 100, true),
       ('Dell XPS 13', 7, 'LTP-2001', 'Compact premium ultrabook', 1.20, 0.0035, 1290.00, 8, true),
       ('Lenovo ThinkPad T14', 7, 'LTP-2002', 'Business-class laptop', 1.50, 0.0038, 1150.00, 10, true),
       ('Asus ROG Strix G15', 7, 'LTP-2003', 'Gaming laptop with dedicated GPU', 2.60, 0.0050, 1650.00, 6, true),
       ('Sony WH-1000XM5 Headphones', 4, 'AUD-3001', 'Noise-cancelling wireless headphones', 0.30, 0.0010, 320.00, 18,
        true),
       ('JBL Charge 5 Speaker', 4, 'AUD-3002', 'Portable Bluetooth speaker', 0.97, 0.0020, 140.00, 20, true),
       ('LG OLED 55" TV', 4, 'AUD-3003', 'Ultra HD OLED television', 17.00, 0.1200, 1190.00, 3, true),
       ('Nvidia RTX 4070 GPU', 3, 'CMP-4001', 'High-end graphics card', 1.90, 0.0030, 680.00, 5, true),
       ('Samsung 1TB NVMe SSD', 3, 'CMP-4002', 'High-speed SSD drive', 0.08, 0.0003, 120.00, 20, true),
       ('Corsair 16GB DDR4 RAM', 3, 'CMP-4003', 'Memory module for PCs', 0.10, 0.0002, 75.00, 25, true),
       ('Coca Cola 1L', 14, 'DRK-6001', 'Sweet carbonated drink', 1.10, 0.0011, 1.40, 100, true),
       ('Still Water 0.5L', 14, 'DRK-6002', 'Mineral drinking water', 0.55, 0.0006, 0.70, 200, true),
       ('Orange Juice 1L', 14, 'DRK-6003', 'Natural orange juice', 1.05, 0.0011, 2.20, 120, true),
       ('Oat Cookies 300g', 13, 'FOO-5001', 'Healthy oat-based cookies', 0.30, 0.0006, 3.50, 60, true),
       ('Corn Flakes 500g', 13, 'FOO-5002', 'Breakfast cereal', 0.45, 0.0008, 4.90, 40, true),
       ('Dark Chocolate 100g', 13, 'FOO-5003', '70% cocoa chocolate bar', 0.12, 0.0002, 2.80, 80, true),
       ('Car Engine Oil 5W-30 4L', 17, 'AUT-7001', 'Synthetic engine oil', 4.20, 0.0050, 32.00, 30, true),
       ('Car Battery 60Ah', 17, 'AUT-7002', 'Standard 60Ah lead-acid battery', 15.00, 0.0150, 85.00, 12, true),
       ('Windshield Washer Fluid 4L', 17, 'AUT-7003', 'Winter windshield washer fluid', 4.20, 0.0060, 6.50, 50, true);

INSERT INTO customers
(customer_name, customer_type, contact_person, email, phone, address, region_id, discount_percent, is_active)
VALUES ('MoldData Logistics SRL', 'business', 'Ion Popescu', 'contact@molddata.md', '+373 60 123456',
        'Str. București 45, Chișinău', 1, 5.00, true),
       ('AgroShop Market', 'business', 'Vasile Moraru', 'sales@agroshop.md', '+373 69 445566',
        'Str. Decebal 12, Bălți', 2, 3.00, true),
       ('Maria Ionescu', 'individual', 'Maria Ionescu', 'maria.ionescu@example.md', '+373 79 222333',
        'Str. Ștefan cel Mare 77, Chișinău', 1, 0.00, true),
       ('Cahul Fresh Store', 'business', 'Dumitru Rotaru', 'info@cahulfresh.md', '+373 67 998877',
        'Str. Republicii 22, Cahul', 3, 4.50, true);


-- ====================================================================
-- ROMANIA ORDERS
-- ====================================================================

-- Order #1 (Business) — TransExpress SRL → Bucharest
INSERT INTO app.orders_distributed
(customer_id, required_delivery_date, status, shipping_address, shipping_region_id, total_amount,
 payment_method, payment_status, notes)
VALUES (1, CURRENT_DATE + INTERVAL '4 days', 'new',
        'Bd. Unirii 12, București', 6,
        1450.00, 'credit_card', 'pending',
        'Urgent corporate delivery');


-- Order #2 (Individual) — Ioana Marinescu → Bucharest
INSERT INTO app.orders_distributed
(customer_id, required_delivery_date, status, shipping_address, shipping_region_id,
 total_amount,
 payment_method, payment_status, notes)
VALUES (2, NOW() + INTERVAL '2 days', 'processing',
        'Str. Mihai Eminescu 5, București', 6,
        320.00, 'card_on_delivery', 'pending',
        'Include gift packaging');


-- Order #3 (Business) — Cluj Retail Group → Cluj
INSERT INTO app.orders_distributed
(customer_id, required_delivery_date, status, shipping_address, shipping_region_id,
 total_amount,
 payment_method, payment_status, notes)
VALUES (1, NOW() + INTERVAL '5 days', 'new',
        'Bul. Vitosha 21, Sofia', 7,
        3890.00, 'bank_transfer', 'pending',
        'Large quantity order – process asap');


-- Order #4 (Business) — TechMarket Romania → Cluj
INSERT INTO app.orders_distributed
(customer_id, required_delivery_date, status, shipping_address, shipping_region_id,
 total_amount,
 payment_method, payment_status, notes)
VALUES (4, NOW() + INTERVAL '3 days', 'processing',
        'Str. Avram Iancu 33, Cluj-Napoca', 7,
        1750.00, 'credit_card', 'paid',
        'Prepaid. Customer requests early dispatch if possible.');

INSERT INTO app.orders_distributed
(customer_id, required_delivery_date, status, shipping_address, shipping_region_id,
 total_amount,
 payment_method, payment_status, notes)
VALUES (1, NOW() + INTERVAL '3 days', 'processing',
        'Str. Avram Iancu 33, Cluj-Napoca', 11,
        1750.00, 'credit_card', 'paid',
        'Prepaid. Customer requests early dispatch if possible.');