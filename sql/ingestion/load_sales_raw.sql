
-- Ingestion strategy:
-- 1) Data is first loaded into a temporary staging table (raw.sales_raw_tmp)
-- 2) Then, it is inserted into the raw layer.

-- Note: This ensures a clean and controlled ingestion process and allows
-- future validation steps before persisting raw data.




-- Temporary staging table for ingestion (_tmp)
DROP TABLE IF EXISTS raw.sales_raw_tmp;

CREATE TABLE raw.sales_raw_tmp (
    order_id TEXT,
    date TEXT,
    customer_age TEXT,
    gender TEXT,
    country TEXT,
    country_state TEXT,
    prod_category TEXT,
    prod_subcategory TEXT,
    quantity TEXT,
    unit_cost TEXT,
    unit_price TEXT
);


-- LOAD CSV into temporal table
\copy raw.sales_raw_tmp FROM 'data/raw/salesdata_1.csv' CSV HEADER DELIMITER ';'


-- Reload final raw table (idempotent)
TRUNCATE TABLE raw.sales_raw;

INSERT INTO raw.sales_raw
SELECT *
FROM raw.sales_raw_tmp;


