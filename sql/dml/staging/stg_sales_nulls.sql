---nulls table

DROP TABLE IF EXISTS stg.sales_nulls;


CREATE TABLE stg.sales_nulls AS
SELECT
*
FROM raw.sales_raw
WHERE
order_id IS NULL
OR TRIM(order_id) = ''
OR date IS NULL
OR customer_age IS NULL
OR gender IS NULL
OR country IS NULL
OR country_state IS NULL
OR prod_category IS NULL
OR prod_subcategory IS NULL
OR quantity IS NULL
OR unit_cost IS NULL
OR unit_price IS NULL;