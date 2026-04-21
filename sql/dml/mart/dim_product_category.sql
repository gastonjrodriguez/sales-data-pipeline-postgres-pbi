--- dim_product_category


CREATE TABLE mart.dim_product_category (
	id_category SMALLSERIAL PRIMARY KEY,
	category_name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO mart.dim_product_category (category_name)
SELECT DISTINCT
prod_category
FROM stg.sales_clean;