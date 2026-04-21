
DROP TABLE IF EXISTS raw.sales_raw;

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
