--- dim_date


CREATE TABLE IF NOT EXISTS mart.dim_date AS
SELECT
d::DATE AS date_id,
EXTRACT(YEAR FROM d) AS year,
EXTRACT(MONTH FROM d) AS month,
EXTRACT(DAY FROM d) AS day,
EXTRACT(QUARTER FROM d) AS quarter
FROM generate_series(
    (SELECT MIN(order_date) FROM stg.sales_clean),
    (SELECT MAX(order_date) FROM stg.sales_clean),
    INTERVAL '1 day'
) AS d;
