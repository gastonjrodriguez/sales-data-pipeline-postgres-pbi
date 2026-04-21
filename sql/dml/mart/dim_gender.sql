--- dim_gender


CREATE TABLE mart.dim_gender (
	id_gender SMALLSERIAL PRIMARY KEY,
	gender_name CHAR(1) NOT NULL UNIQUE
);

INSERT INTO mart.dim_gender (gender_name)
SELECT DISTINCT gender
FROM stg.sales_clean;