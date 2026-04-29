-----------------------------
-- Load CSV Files from S3
-----------------------------

-- Replace the placeholders below before running:
--   <S3_BUCKET_NAME>
--   <REDSHIFT_IAM_ROLE_ARN>
--
-- Example S3 object layout:
--   s3://<S3_BUCKET_NAME>/grocery-demo/raw/sales.csv
--   s3://<S3_BUCKET_NAME>/grocery-demo/raw/items.csv

TRUNCATE stg_sales;

COPY stg_sales
FROM 's3://<S3_BUCKET_NAME>/grocery-demo/raw/sales.csv'
IAM_ROLE '<REDSHIFT_IAM_ROLE_ARN>'
FORMAT AS CSV
TIMEFORMAT 'auto'
TRIMBLANKS
BLANKSASNULL
EMPTYASNULL
ACCEPTINVCHARS;

TRUNCATE stg_items;

COPY stg_items
FROM 's3://<S3_BUCKET_NAME>/grocery-demo/raw/items.csv'
IAM_ROLE '<REDSHIFT_IAM_ROLE_ARN>'
FORMAT AS CSV
TRIMBLANKS
BLANKSASNULL
EMPTYASNULL
ACCEPTINVCHARS;

SELECT COUNT(*) AS stg_sales_rows FROM stg_sales;
SELECT COUNT(*) AS stg_items_rows FROM stg_items;
