--------------------
-- Validation Checks
--------------------

SELECT MIN(saleDate) AS min_saleDate, MAX(saleDate) AS max_saleDate
FROM stg_sales;

SELECT COUNT(*) AS dim_item_rows FROM dim_item;
SELECT COUNT(*) AS dim_date_rows FROM dim_date;
SELECT COUNT(*) AS dim_store_rows FROM dim_store;
SELECT COUNT(*) AS fact_sales_rows FROM fact_sales;

SELECT
  (SELECT COUNT(*) FROM dim_item) AS dim_item_cnt,
  (SELECT COUNT(*) FROM dim_date) AS dim_date_cnt,
  (SELECT COUNT(*) FROM dim_store) AS dim_store_cnt,
  (SELECT COUNT(*) FROM fact_sales) AS fact_sales_cnt;

SELECT
  f.yyyymm,
  d.year,
  d.month,
  s.region,
  i.type,
  COUNT(*) AS line_items,
  SUM(f.price) AS revenue
FROM fact_sales f
JOIN dim_date d ON d.date_key = f.sale_date
JOIN dim_store s ON s.store_id = f.store_id
JOIN dim_item i ON i.sku = f.sku
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1
LIMIT 25;

---------------
-- Total Sales
---------------

SELECT
  COUNT(*) AS total_transactions,
  SUM(price) AS total_sales
FROM fact_sales;

-----------------
-- Sales by Store
-----------------

SELECT
  store_id,
  DATE_PART(year, sale_date) AS year,
  DATE_PART(quarter, sale_date) AS quarter,
  COUNT(*) AS total_transactions,
  SUM(price) AS total_sales
FROM fact_sales
GROUP BY store_id, year, quarter
ORDER BY store_id, year, quarter;

----------------
-- Sales by Time
----------------

SELECT
  DATE_PART(year, sale_date) AS year,
  DATE_PART(quarter, sale_date) AS quarter,
  COUNT(*) AS total_transactions,
  SUM(price) AS total_sales
FROM fact_sales
GROUP BY year, quarter
ORDER BY year, quarter;

----------------------
-- Top Selling Products
----------------------

SELECT
  DATE_PART(year, f.sale_date) AS year,
  DATE_PART(quarter, f.sale_date) AS quarter,
  f.sku,
  i.name,
  COUNT(*) AS total_sold,
  SUM(f.price) AS total_revenue
FROM fact_sales f
JOIN dim_item i ON f.sku = i.sku
GROUP BY year, quarter, f.sku, i.name
ORDER BY year, quarter, total_revenue DESC
LIMIT 20;

----------------
-- Table Metadata
----------------

SELECT *
FROM svv_table_info
WHERE schema = 'public'
ORDER BY "table";

--------------------
-- Query Execution Plan
--------------------

EXPLAIN
SELECT
  store_id,
  DATE_PART(quarter, sale_date),
  COUNT(*)
FROM fact_sales
GROUP BY store_id, DATE_PART(quarter, sale_date);
