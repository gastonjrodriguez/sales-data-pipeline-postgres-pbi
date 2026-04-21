--- staging constraints

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