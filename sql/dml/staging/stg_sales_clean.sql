---stg clean table

DROP TABLE IF EXISTS stg.sales_clean;


CREATE TABLE stg.sales_clean AS
SELECT
TRIM(order_id) AS order_id,
TO_DATE(TRIM(date), 'MM/DD/YY') AS order_date,
REGEXP_REPLACE(TRIM(customer_age), '\.0$', '')::SMALLINT AS customer_age,
TRIM(gender)::CHAR(1) AS gender,
TRIM(country) AS country,
TRIM(country_state) AS country_state,
TRIM(prod_category) AS prod_category,
TRIM(prod_subcategory) AS prod_subcategory,
REGEXP_REPLACE(TRIM(quantity), '\.0$', '')::INT AS quantity,
ROUND(NULLIF(TRIM(unit_cost), '')::NUMERIC, 2) AS unit_cost,
ROUND(NULLIF(TRIM(unit_price), '')::NUMERIC, 2) AS unit_price
FROM raw.sales_raw
WHERE order_id IS NOT NULL
AND TRIM(order_id) <> ''
AND TRIM(order_id) <> '34866'; -- remove KNOWN bad record (empty order. It only has an order_id)


-- Data quality check (duplicates)
-- SELECT order_id,
--		  COUNT(*)
-- FROM stg.sales_clean
-- GROUP BY order_id
-- HAVING COUNT(*) > 1;