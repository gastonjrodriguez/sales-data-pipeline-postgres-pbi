--- dim_country


CREATE TABLE IF NOT EXISTS mart.dim_country (
	id_country SMALLSERIAL PRIMARY KEY,
	country_name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO mart.dim_country (country_name)
SELECT DISTINCT country
FROM stg.sales_clean;