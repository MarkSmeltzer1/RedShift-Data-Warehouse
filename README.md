# Retail Analytics Data Warehouse (AWS Redshift)

## Overview

Designed and implemented a scalable cloud data warehouse using Amazon Redshift and Amazon S3 to process and analyze 17M+ sales records across a simulated 10-store retail chain.

The system transforms raw transactional data into a star schema and enables high-performance SQL analytics for store performance, product trends, and time-based reporting.

This project simulates how enterprise retail systems transition from transactional databases to scalable cloud analytics platforms for business decision-making.

## Tech Stack

- Cloud: Amazon S3, Amazon Redshift
- Languages: SQL, Python
- Data Processing: ETL pipelines, CSV exports, Redshift `COPY`
- Architecture: Star schema, dimensional modeling, cloud data warehousing
- Tools: Redshift Query Editor v2, `EXPLAIN` plans, Redshift system views

## Business Problem

Retail management needed a centralized analytics system to evaluate sales performance across multiple store locations. The goal was to move beyond a local transactional database and build a warehouse that could support business reporting at scale.

The warehouse is designed to answer questions such as:

- What is total revenue and transaction volume across all stores?
- Which store locations perform best by quarter?
- How do sales trends change over time?
- Which products generate the most revenue and sales volume?
- Is the warehouse data model consistent after loading and transformation?

## Architecture

The project follows a cloud-based ETL pattern:

1. Export structured data from SQLite to CSV.
2. Upload CSV files to Amazon S3.
3. Load raw files into Redshift staging tables with `COPY`.
4. Transform staging data into a star schema.
5. Run analytical SQL queries for reporting and validation.

## Data Model

The warehouse uses a star schema optimized for analytical reporting:

| Table | Purpose |
| --- | --- |
| `fact_sales` | Transaction-level sales data with store, item, date, customer, and price fields. |
| `dim_item` | Product attributes including SKU, name, manufacturer, size, type, and base price. |
| `dim_date` | Calendar attributes for time-based reporting across 2025. |
| `dim_store` | Simulated store metadata including store ID, store name, and region. |

The fact table uses a Redshift distribution key on `store_id` and a sort key on `sale_date`, `store_id`, and `sku` to support store-level and time-based reporting queries.

## Key Features

- Built a cloud warehouse workflow using Amazon S3 and Amazon Redshift.
- Loaded CSV source data into Redshift staging tables using `COPY`.
- Designed a star schema for scalable analytical reporting.
- Simulated a multi-store retail environment by scaling a single-store dataset to support enterprise-level analytics.
- Wrote SQL validation checks for staging, dimension, and fact tables.
- Created reporting queries for total sales, store performance, quarterly trends, and top-selling products.
- Used Redshift metadata views and `EXPLAIN` plans to inspect table structure and query execution.

## Business Questions Answered

| Business question | Warehouse approach | Query location |
| --- | --- | --- |
| What is total sales activity across the warehouse? | Count transactions in `fact_sales` and sum total revenue. | `sql/04_validation_and_reports.sql` |
| Which stores perform best by quarter? | Group sales by `store_id`, year, and quarter. | `sql/04_validation_and_reports.sql` |
| How do sales trend over time? | Aggregate sales by year and quarter using `sale_date`. | `sql/04_validation_and_reports.sql` |
| Which products are top sellers? | Join `fact_sales` to `dim_item` and rank products by volume and revenue. | `sql/04_validation_and_reports.sql` |
| Did the warehouse load correctly? | Compare row counts across staging, dimension, and fact tables. | `sql/04_validation_and_reports.sql` |
| How does Redshift process the report query? | Use `EXPLAIN` to review the query execution plan. | `sql/04_validation_and_reports.sql` |

## Example Outputs

The reporting SQL produces:

- Total revenue and transaction counts
- Sales by store, year, and quarter
- Sales trends by quarter
- Top-selling products by SKU and product name
- Redshift table metadata from `svv_table_info`
- Query execution plans using `EXPLAIN`

## Why Redshift

Compared with SQLite, Amazon Redshift is better suited for analytical workloads because it provides:

- Columnar storage for faster aggregation queries
- Massively parallel processing for large datasets
- Distribution and sort keys for query optimization
- Native integration with Amazon S3 for data loading
- Scalable infrastructure for business intelligence and reporting

## Repository Structure

```text
.
|-- scripts/
|   `-- export_to_csv.py
|-- sql/
|   |-- 01_create_staging_tables.sql
|   |-- 02_load_from_s3.sql
|   |-- 03_build_star_schema.sql
|   `-- 04_validation_and_reports.sql
|-- data/
`-- outputs/
```

## Security Notes

Sensitive AWS values have been replaced with placeholders in `sql/02_load_from_s3.sql`:

- `<S3_BUCKET_NAME>`
- `<REDSHIFT_IAM_ROLE_ARN>`

Do not commit AWS credentials, real IAM role ARNs, private S3 bucket names, database passwords, or local environment files to GitHub.

## Running the Project

1. Place the source SQLite database in the project root or update `DB_PATH` in `scripts/export_to_csv.py`.
2. Export SQLite tables to CSV:

```bash
python scripts/export_to_csv.py
```

3. Upload the generated CSV files from `data/raw/` to Amazon S3.
4. Run the SQL files in Redshift Query Editor v2:

```text
sql/01_create_staging_tables.sql
sql/02_load_from_s3.sql
sql/03_build_star_schema.sql
sql/04_validation_and_reports.sql
```
