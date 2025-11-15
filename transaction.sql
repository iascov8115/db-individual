CREATE EXTENSION IF NOT EXISTS dblink;

SELECT dblink_connect('conn_romania',
                      'host=db_romania port=5432 dbname=postgres user=admin password=admin');
SELECT dblink_connect('conn_bulgaria',
                      'host=db_bulgaria port=5432 dbname=postgres user=admin password=admin');

-- Начинаем транзакции на удалённых узлах
SELECT dblink_exec('conn_romania', 'BEGIN');
SELECT dblink_exec('conn_bulgaria', 'BEGIN');

SELECT dblink_exec('conn_romania',
                   'UPDATE app.orders
                    SET status = ''shipped'',
                        notes = notes || '' | Tracking: RO-12345-TRACK'',
                        payment_status = ''paid''
                    WHERE shipping_region_id = 7
                      AND customer_id = 4
                      AND status = ''processing''');

SELECT dblink_exec('conn_bulgaria',
                   'UPDATE app.orders
                    SET status = ''shipped'',
                        required_delivery_date = required_delivery_date + INTERVAL ''1 day'',
                        notes = notes || '' | Tracking: BG-67890-TRACK''
                    WHERE shipping_region_id = 11
                      AND customer_id = 1
                      AND status = ''processing''');

SELECT dblink_exec('conn_romania', 'PREPARE TRANSACTION ''tnx1''');
SELECT dblink_exec('conn_bulgaria', 'PREPARE TRANSACTION ''tnx2''');

SELECT dblink_exec('conn_romania', 'COMMIT PREPARED  ''tnx1''');
SELECT dblink_exec('conn_bulgaria', 'COMMIT PREPARED  ''tnx2''');

SELECT dblink_disconnect('conn_romania');
SELECT dblink_disconnect('conn_bulgaria');

SELECT 'Romania orders:' as source, order_id, customer_id, status, notes
FROM app.orders_romania
WHERE customer_id = 4
UNION ALL
SELECT 'Bulgaria orders:' as source, order_id, customer_id, status, notes
FROM app.orders_bulgaria
WHERE customer_id = 1;