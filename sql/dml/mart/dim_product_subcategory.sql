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