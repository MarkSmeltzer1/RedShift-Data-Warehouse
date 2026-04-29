# Amazon Redshift Grocery Store Data Warehouse

This project demonstrates a cloud data warehouse built in Amazon Redshift for a grocery store sales dataset. It migrates SQLite source data into CSV files, stages those files in Amazon S3, loads them into Redshift staging tables, and transforms them into a star schema for analytical reporting.

## Project Overview

The original grocery store simulation used a local SQLite database with product and sales data. Redshift was used to show how the same business data can scale into a cloud analytics workflow with columnar storage, massively parallel processing, distribution keys, sort keys, and SQL-based reporting.

The warehouse supports quarterly reporting across a simulated 10-store grocery chain, including:

- Total transaction and revenue reporting
- Sales performance by store
- Sales trends by year and quarter
- Top-selling product analysis
- Metadata inspection with Redshift system views
- Query plan review with `EXPLAIN`

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

## Data Flow

1. Export `items` and `sales` tables from SQLite to CSV.
2. Upload `items.csv` and `sales.csv` to an S3 bucket.
3. Use Redshift `COPY` commands to load CSV files into staging tables.
4. Transform staging tables into a star schema:
   - `dim_item`
   - `dim_date`
   - `dim_store`
   - `fact_sales`
5. Run validation and quarterly business reporting queries.

## Business Questions Answered

The warehouse was designed around a quarterly sales reporting problem for a multi-store grocery business. Corporate management needed a single Redshift warehouse that could combine transaction data, product details, date attributes, and store information for reporting across all store locations.

| Business question | Warehouse approach | Query location |
| --- | --- | --- |
| What is total sales activity across the warehouse? | Count all records in `fact_sales` and sum transaction revenue. | `sql/04_validation_and_reports.sql` |
| Which stores have the highest or lowest sales activity? | Group `fact_sales` by `store_id`, year, and quarter to compare store performance. | `sql/04_validation_and_reports.sql` |
| How do sales trend over time? | Use `sale_date` and quarterly grouping to analyze seasonality across 2025. | `sql/04_validation_and_reports.sql` |
| Which products are top sellers? | Join `fact_sales` to `dim_item`, then rank SKUs by quantity sold and total revenue. | `sql/04_validation_and_reports.sql` |
| Is the warehouse structure valid after loading? | Check staging, dimension, and fact table row counts, then run join sanity checks. | `sql/04_validation_and_reports.sql` |
| How is Redshift processing the report query? | Use `EXPLAIN` to inspect the query execution plan. | `sql/04_validation_and_reports.sql` |

## Report Outputs

The reporting SQL produces the following outputs:

- Total transaction count and total sales revenue
- Sales totals by store, year, and quarter
- Sales totals by year and quarter
- Top-selling products by SKU and product name
- Table metadata from Redshift system views
- Query execution plan for a grouped sales report

The project also demonstrates why Redshift is a better fit than SQLite for larger analytical workloads: the fact table can be distributed by store, sorted by sale date and product, and queried with Redshift's columnar storage and parallel processing engine.

## Security Notes

The original Redshift load script included a project-specific S3 bucket path and IAM role ARN. Those values were replaced with placeholders in `sql/02_load_from_s3.sql`:

- `<S3_BUCKET_NAME>`
- `<REDSHIFT_IAM_ROLE_ARN>`

Before running the load script, replace those placeholders with your own AWS resources. Do not commit real AWS account IDs, IAM role ARNs, access keys, secret keys, database passwords, or private S3 bucket names to GitHub.

## Running the Project

1. Place the source SQLite database in the project root or update `DB_PATH` in `scripts/export_to_csv.py`.
2. Run the export script to generate CSV files:

```bash
python scripts/export_to_csv.py
```

3. Upload the generated CSV files from `data/raw/` to your S3 bucket.
4. Run the SQL files in Redshift Query Editor v2 in this order:

```text
sql/01_create_staging_tables.sql
sql/02_load_from_s3.sql
sql/03_build_star_schema.sql
sql/04_validation_and_reports.sql
```
