
------------------------------------------- RAW LAYER -------------------------------------------

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS mart;

CREATE TABLE raw.sales_raw (
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

---how to get the raw data:
-- \copy raw.sales_raw FROM 'C:\Users\Usuario\Desktop\PROJECTS\sales_project_pbi_sql\data\salesdata_1.csv' CSV HEADER DELIMITER ';'



------------------------------------------- STAGING LAYER -------------------------------------------


---stg clean table
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
ROUND(unit_cost::NUMERIC,2) AS unit_cost,
ROUND(unit_price::NUMERIC,2) AS unit_price
FROM raw.sales_raw
WHERE TRIM(order_id) <> '';


---nulls table
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


--- we can delete the null order
DELETE FROM stg.sales_clean
WHERE order_id = '34866';


--- check on duplicated orders
-- SELECT
-- order_id,
-- COUNT(order_id) AS duplicates_amount
-- FROM stg.sales_clean
-- GROUP BY order_id
-- HAVING COUNT(order_id) > 1;


---Data Quality for current and future records
ALTER TABLE stg.sales_clean
ADD CONSTRAINT pk_order PRIMARY KEY (order_id);

ALTER TABLE stg.sales_clean
ADD CONSTRAINT chk_customer_age CHECK (customer_age BETWEEN 1 AND 99);

ALTER TABLE stg.sales_clean
ADD CONSTRAINT chk_quantity CHECK (quantity > 0);

ALTER TABLE stg.sales_clean
ADD CONSTRAINT chk_unit_cost CHECK (unit_cost > 0);

ALTER TABLE stg.sales_clean
ADD CONSTRAINT chk_unit_price CHECK (unit_price > 0);

--para chequearlas en psql Tool: \d stg.sales_clean

------------------------------------------- MART LAYER -------------------------------------------


--- dim_date
CREATE TABLE mart.dim_date AS
SELECT
DISTINCT order_date AS date_id,
EXTRACT(YEAR FROM order_date) AS year,
EXTRACT(MONTH FROM order_date) AS month,
EXTRACT(DAY FROM order_date) AS day,
EXTRACT(QUARTER FROM order_date) AS quarter
FROM stg.sales_clean;

ALTER TABLE mart.dim_date
ADD PRIMARY KEY (date_id);


--- dim_gender
CREATE TABLE mart.dim_gender (
	id_gender SMALLSERIAL PRIMARY KEY,
	gender_name CHAR(1) NOT NULL UNIQUE
);

INSERT INTO mart.dim_gender (gender_name)
SELECT DISTINCT gender
FROM stg.sales_clean;

--- dim_country
CREATE TABLE mart.dim_country (
	id_country SMALLSERIAL PRIMARY KEY,
	country_name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO mart.dim_country (country_name)
SELECT DISTINCT country
FROM stg.sales_clean;


--- dim_state
CREATE TABLE mart.dim_state (
	id_state SMALLSERIAL PRIMARY KEY,
	state_name VARCHAR(30) NOT NULL,
	id_country SMALLINT NOT NULL,
	UNIQUE(state_name, id_country)
);


INSERT INTO mart.dim_state (state_name, id_country)
SELECT DISTINCT
s.country_state,
c.id_country
FROM stg.sales_clean s
INNER JOIN mart.dim_country c
ON s.country = c.country_name; 


--- dim_product_category
CREATE TABLE mart.dim_product_category (
	id_category SMALLSERIAL PRIMARY KEY,
	category_name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO mart.dim_product_category (category_name)
SELECT DISTINCT
prod_category
FROM stg.sales_clean;


--- dim_product_subcategory
CREATE TABLE mart.dim_product_subcategory(
	id_subcategory SERIAL PRIMARY KEY,
	subcategory_name VARCHAR(30) NOT NULL,
	id_category SMALLINT NOT NULL,
	UNIQUE(subcategory_name, id_category)
);

INSERT INTO mart.dim_product_subcategory (subcategory_name, id_category)
SELECT DISTINCT
s.prod_subcategory,
p.id_category
FROM stg.sales_clean s
INNER JOIN mart.dim_product_category p
ON s.prod_category = p.category_name;


--- dim_fact_sales

CREATE TABLE mart.fact_sales AS
SELECT
s.order_id::INT AS order_id,
s.order_date AS date_id,
g.id_gender,
st.id_state,
ps.id_subcategory,
s.customer_age,
s.quantity,
s.unit_cost,
s.unit_price
FROM stg.sales_clean s
JOIN mart.dim_gender g
ON s.gender = g.gender_name
JOIN mart.dim_state st
ON s.country_state = st.state_name
JOIN mart.dim_product_subcategory ps
ON s.prod_subcategory = ps.subcategory_name;

ALTER TABLE mart.fact_sales
ADD PRIMARY KEY (order_id)


--- FK (Foreing Key(s))

--dim_fact_sales
ALTER TABLE mart.fact_sales
ADD FOREIGN KEY (id_gender)
REFERENCES mart.dim_gender(id_gender);

ALTER TABLE mart.fact_sales
ADD FOREIGN KEY (id_state)
REFERENCES mart.dim_state(id_state);

ALTER TABLE mart.fact_sales
ADD FOREIGN KEY (id_subcategory)
REFERENCES mart.dim_product_subcategory(id_subcategory);

ALTER TABLE mart.fact_sales
ADD FOREIGN KEY (date_id)
REFERENCES mart.dim_date(date_id);

--dim_state
ALTER TABLE mart.dim_state
ADD FOREIGN KEY (id_country)
REFERENCES mart.dim_country(id_country);


--dim_product_subcategory
ALTER TABLE mart.dim_product_subcategory
ADD FOREIGN KEY (id_category)
REFERENCES mart.dim_product_category(id_category);


--- Indexes
CREATE INDEX idx_fact_date ON mart.fact_sales(date_id);
CREATE INDEX idx_fact_state ON mart.fact_sales(id_state);
CREATE INDEX idx_fact_prod_sub_category ON mart.fact_sales(id_subcategory);