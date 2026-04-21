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
