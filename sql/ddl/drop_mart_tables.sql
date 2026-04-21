-- DROP fact
DROP TABLE IF EXISTS mart.fact_sales;

-- DROP dims
DROP TABLE IF EXISTS mart.dim_product_subcategory;
DROP TABLE IF EXISTS mart.dim_product_category;
DROP TABLE IF EXISTS mart.dim_state;
DROP TABLE IF EXISTS mart.dim_country;
DROP TABLE IF EXISTS mart.dim_gender;
DROP TABLE IF EXISTS mart.dim_date;