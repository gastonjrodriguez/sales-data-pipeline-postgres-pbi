
---mart constraints

-- dim_date PK
ALTER TABLE mart.dim_date
ADD CONSTRAINT pk_dim_date
PRIMARY KEY (date_id);

-- fact_sales PK
ALTER TABLE mart.fact_sales
ADD CONSTRAINT pk_fact_sales
PRIMARY KEY (order_id);

-- Foreign Keys (relationship between dimensions and fact_sales)
ALTER TABLE mart.fact_sales
ADD CONSTRAINT fk_fact_gender
FOREIGN KEY (id_gender)
REFERENCES mart.dim_gender(id_gender);

ALTER TABLE mart.fact_sales
ADD CONSTRAINT fk_fact_state
FOREIGN KEY (id_state)
REFERENCES mart.dim_state(id_state);

ALTER TABLE mart.fact_sales
ADD CONSTRAINT fk_fact_subcategory
FOREIGN KEY (id_subcategory)
REFERENCES mart.dim_product_subcategory(id_subcategory);

ALTER TABLE mart.fact_sales
ADD CONSTRAINT fk_fact_date
FOREIGN KEY (date_id)
REFERENCES mart.dim_date(date_id);


-- Foreing Keys (relationship between dimensions)
ALTER TABLE mart.dim_state
ADD CONSTRAINT fk_state_country
FOREIGN KEY (id_country)
REFERENCES mart.dim_country(id_country);

ALTER TABLE mart.dim_product_subcategory
ADD CONSTRAINT fk_subcategory_category
FOREIGN KEY (id_category)
REFERENCES mart.dim_product_category(id_category);