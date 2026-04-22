# 📊 Sales Data Pipeline (PostgreSQL + Power BI)

This project implements an end-to-end data pipeline using PostgreSQL, transforming raw CSV data into a star schema model ready for analytics and visualization in Power BI.
It improves the existing script (`old_data_model.sql`).

---

## Overview

The pipeline ingests raw sales data from a CSV file, cleans and standardizes it, and builds a dimensional model (star schema) for analytical reporting.
The objective is to generate a dashboard to analyze metrics such as:

* Monthly Margin % vs 3-Month Rolling Average
* Month-over-Month Margin change (pp)
* Customers' analysis (age distribution, top 10 most sold items)
* Margin per product category
* Sold units per product category
* Total margin per product category

---

### Key Features

* Layered architecture (raw → staging → mart)
* Idempotent pipeline (safe to re-run)
* Data quality checks using constraints
* Star schema optimized for BI tools
* Integration with Power BI

---

## Key Insights

* Margin % shows a steady upward trend throughout the period
* A significant structural increase occurs in early 2016 (~+13 pp)
* Rolling 3-month margin confirms sustained improvement
* Margin volatility decreases after the increase, suggesting stabilization
* Late 2015 shows minor margin pressure before the growth phase
* Most consumers are in their early to mid-30s, indicating a core customer segment

---

## Architecture

The project follows a medallion-style architecture:

* **raw**: stores ingested data
* **staging (stg)**: data cleaning and transformation
* **mart**: dimensional model (fact + dimensions)

---

## Project Structure

```
sales_project_pbi_sql/
│
├── data/
│   └── raw/                # CSV goes here (not included)
│
├── sql/
│   ├── ddl/                # schemas & table creation
│   ├── dml/                # transformations (staging & mart)
│   ├── ingestion/          # CSV loading logic
│   ├── constraints/        # PKs, FKs, checks
│   ├── indexes/            # performance optimization
│
├── pipeline/
│   ├── run_all.sql         # main entry point
│   ├── run_ddl.sql
│   ├── run_ingestion.sql
│   ├── run_dml.sql
│
├── powerbi/
│   ├── sales_analytics.pbix # dashboard
│   └── images/              # .png for dashboard
│
├── docs/
│   └── e-r_model.pgerd
│
├── old_model_deprecated/
│   └── old_data_model.sql
│
├── README.md
└── .gitignore
```

---

## Requirements

* PostgreSQL installed
* `psql` available in PATH
* Power BI Desktop (optional, for visualization)

---

## Data Source

The dataset used in this project comes from Kaggle:
https://www.kaggle.com/datasets/thedevastator/analyzing-customer-spending-habits-to-improve-sa

Rename the downloaded file to `salesdata_1.csv` and place it here before running the pipeline:

```
data/raw/salesdata_1.csv
```

---

## How to Run

### Create database

Open psql and run:

```
CREATE DATABASE sales_database;
```

### Option A: if psql is in PATH

From the project root :

```
cd <path to sales_project_pbi_sql>
```

```
psql -U <your_user> -d sales_database -f pipeline/run_all.sql
```

#### Option B: if psql is not in PATH (Windows)

```
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -U <your_user> -d sales_database -f pipeline/run_all.sql
```

---

## Expected Results

```
raw.sales_raw     → 34867 rows  
stg.sales_clean   → 34866 rows  
mart.fact_sales   → 34866 rows  
```

---

## Technical Decisions

### Idempotent Pipeline

The pipeline is designed to be fully idempotent:

* `DROP TABLE IF EXISTS` used for clean rebuilds
* `TRUNCATE` used for controlled reloads
* Centralized drop logic for mart layer (due to foreign keys)

This ensures consistent results across executions.

---

### Ingestion Strategy

Data is loaded using a two-step process:

1. Load CSV into a temporary table (`raw.sales_raw_tmp`)
2. Insert into final raw table (`raw.sales_raw`)

Benefits:

* Enables future validation before persistence
* Decouples ingestion from storage
* Improves robustness

---

### CREATE TABLE vs CREATE TABLE AS

Two approaches were used:

* `CREATE TABLE [...] + INSERT` → dimensions
* `CREATE TABLE AS SELECT` → fact table and date dimension

Rationale:

* Better control over schema and constraints for dimensions
* Simpler transformation logic for derived tables

---

### Data Quality

Data validation is enforced using:

* Primary keys
* Foreign keys
* Check constraints (e.g., positive quantities, valid age range)
* Explicit filtering of known invalid records

---

### Date Dimension Design

Initially, the date dimension was derived from transactional data.
It was later replaced with a continuous calendar using `generate_series` to:

* Avoid gaps in dates
* Enable time intelligence in Power BI
* Ensure compatibility with BI best practices

---

### Data Model

A star schema was implemented:

* **Fact table**: `fact_sales`
* **Dimensions**:

  * date
  * gender
  * country
  * state
  * product category
  * product subcategory

This structure optimizes analytical queries and BI performance.

---

## Power BI Integration

The mart layer is connected to Power BI to build dashboards.

Steps:

1. Connect to PostgreSQL
2. Load fact and dimension tables
3. Define relationships
4. Mark `dim_date` as Date table

---

## Future Improvements

* Add automated data quality tests
* Implement incremental loading
* Migrate transformations to dbt
* Add orchestration (Airflow / Prefect)

---

## Author

Gaston Rodriguez