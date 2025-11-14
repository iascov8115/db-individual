-- test
INSERT INTO app.regions (region_name, country, region_code, description)
VALUES ('Test Region', 'Moldova', 'TST', 'Test description');

UPDATE app.regions
SET description = 'Updated description'
WHERE region_code = 'TST';

DELETE
FROM app.regions
WHERE region_code = 'TST';