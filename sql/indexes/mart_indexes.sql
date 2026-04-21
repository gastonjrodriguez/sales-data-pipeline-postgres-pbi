--- Indexes
CREATE INDEX IF NOT EXISTS idx_fact_date ON mart.fact_sales(date_id);
CREATE INDEX IF NOT EXISTS idx_fact_state ON mart.fact_sales(id_state);
CREATE INDEX IF NOT EXISTS idx_fact_prod_sub_category ON mart.fact_sales(id_subcategory);