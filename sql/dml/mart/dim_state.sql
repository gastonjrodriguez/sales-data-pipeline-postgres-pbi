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