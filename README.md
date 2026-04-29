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
├── scripts/
│   └── export_to_csv.py
├── sql/
│   ├── 01_create_staging_tables.sql
│   ├── 02_load_from_s3.sql
│   ├── 03_build_star_schema.sql
│   └── 04_validation_and_reports.sql
├── data/
└── outputs/
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

## Notes

The project presentation is not included in this repository. The repository focuses on the Redshift warehouse scripts, export workflow, and project documentation needed to reproduce the data warehouse.
