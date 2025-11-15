INSERT INTO customers
(customer_name, customer_type, contact_person, email, phone, address, region_id, discount_percent,
 is_active)
VALUES ('TransExpress SRL', 'business', 'Andrei Popa', 'office@transexpress.ro', '+40 721 334455',
        'Bd. Unirii 12, București', 6, 6.50, TRUE),
       ('Cluj Retail Group', 'business', 'Cătălin Horia', 'contact@clujretail.ro', '+40 742 887766',
        'Str. Memorandumului 18, Cluj-Napoca', 7, 3.50, TRUE),
       ('Ioana Marinescu', 'individual', 'Ioana Marinescu', 'ioana.marinescu@example.ro', '+40 723 445500',
        'Str. Mihai Eminescu 5, București', 6, 0.00, TRUE),
       ('TechMarket Romania', 'business', 'Gheorghe Iliescu', 'sales@techmarket.ro', '+40 733 556677',
        'Str. Avram Iancu 33, Cluj-Napoca', 7, 2.00, TRUE);
