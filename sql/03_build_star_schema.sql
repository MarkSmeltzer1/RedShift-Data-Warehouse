-------------------------------------
-- Create Dimension Item Table
-------------------------------------

DROP TABLE IF EXISTS dim_item;

CREATE TABLE dim_item (
  sku           INT NOT NULL,
  name          VARCHAR(255),
  manufacturer  VARCHAR(255),
  size          VARCHAR(50),
  type          VARCHAR(100),
  base_price    DECIMAL(10,2),
  PRIMARY KEY (sku)
);

INSERT INTO dim_item (sku, name, manufacturer, size, type, base_price)
SELECT
  sku,
  name,
  manufacturer,
  size,
  COALESCE(NULLIF(type, ''), 'Unknown') AS type,
  NULLIF(REPLACE(basePrice, '$', ''), '')::DECIMAL(10,2) AS base_price
FROM stg_items;

-------------------------------------
-- Create Dimension Date Table
-------------------------------------

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
  date_key     DATE PRIMARY KEY,
  yyyymm       CHAR(6),
  year         SMALLINT,
  month        SMALLINT,
  day          SMALLINT,
  day_of_week  SMALLINT
);

INSERT INTO dim_date (date_key, yyyymm, year, month, day, day_of_week)
SELECT
  d::DATE AS date_key,
  TO_CHAR(d::DATE, 'YYYYMM') AS yyyymm,
  EXTRACT(YEAR FROM d)::SMALLINT,
  EXTRACT(MONTH FROM d)::SMALLINT,
  EXTRACT(DAY FROM d)::SMALLINT,
  EXTRACT(DOW FROM d)::SMALLINT
FROM (
  SELECT DATEADD(day, seq, '2025-01-01'::DATE) AS d
  FROM (
    SELECT ROW_NUMBER() OVER () - 1 AS seq
    FROM pg_catalog.pg_class
    LIMIT 366
  ) x
) t
WHERE d <= '2025-12-31'::DATE;

-------------------------------------
-- Create Dimension Store Table
-------------------------------------

DROP TABLE IF EXISTS dim_store;

CREATE TABLE dim_store (
  store_id    INT PRIMARY KEY,
  store_name  VARCHAR(50),
  region      VARCHAR(20)
);

INSERT INTO dim_store (store_id, store_name, region)
SELECT
  n AS store_id,
  'Store ' || LPAD(n::VARCHAR, 2, '0') AS store_name,
  CASE
    WHEN n BETWEEN 1 AND 3 THEN 'North'
    WHEN n BETWEEN 4 AND 6 THEN 'Central'
    ELSE 'South'
  END AS region
FROM (
  SELECT ROW_NUMBER() OVER () AS n
  FROM pg_catalog.pg_class
  LIMIT 10
) t;

-------------------------------------
-- Create Fact Sales Table
-------------------------------------

DROP TABLE IF EXISTS fact_sales;

CREATE TABLE fact_sales (
  sale_date    DATE NOT NULL,
  yyyymm       CHAR(6) NOT NULL,
  customerNum  INT NOT NULL,
  sku          INT NOT NULL,
  store_id     INT NOT NULL,
  price        DECIMAL(10,2) NOT NULL
)
DISTKEY (store_id)
SORTKEY (sale_date, store_id, sku);

INSERT INTO fact_sales (sale_date, yyyymm, customerNum, sku, store_id, price)
SELECT
  TO_DATE(s.saleDate, 'YYYYMMDD') AS sale_date,
  TO_CHAR(TO_DATE(s.saleDate, 'YYYYMMDD'), 'YYYYMM') AS yyyymm,
  s.customerNum,
  s.sku,
  d.store_id,
  s.price::DECIMAL(10,2) AS price
FROM stg_sales s
CROSS JOIN dim_store d;
