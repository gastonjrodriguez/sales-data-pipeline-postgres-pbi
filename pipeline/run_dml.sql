
-- [MART RESET]
\i sql/ddl/drop_mart_tables.sql

-- STAGING
\i sql/dml/staging/stg_sales_clean.sql
\i sql/dml/staging/stg_sales_nulls.sql

-- STAGING CONSTRAINTS
\i sql/constraints/staging_constraints.sql


-- MART (dimensions)
\i sql/dml/mart/dim_date.sql
\i sql/dml/mart/dim_gender.sql
\i sql/dml/mart/dim_country.sql
\i sql/dml/mart/dim_state.sql
\i sql/dml/mart/dim_product_category.sql
\i sql/dml/mart/dim_product_subcategory.sql

-- MART (fact table) 
\i sql/dml/mart/fact_sales.sql

-- MART CONSTRAINTS
\i sql/constraints/mart_constraints.sql

-- MART INDEXES
\i sql/indexes/mart_indexes.sql