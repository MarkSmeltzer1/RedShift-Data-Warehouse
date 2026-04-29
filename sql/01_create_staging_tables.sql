-------------------------
-- Create Staging Tables
-------------------------

DROP TABLE IF EXISTS stg_items;

CREATE TABLE stg_items (
  sku           INT,
  name          VARCHAR(255),
  manufacturer  VARCHAR(255),
  size          VARCHAR(50),
  type          VARCHAR(100),
  basePrice     VARCHAR(20)
);

DROP TABLE IF EXISTS stg_sales;

CREATE TABLE stg_sales (
  saleDate     VARCHAR(8),
  customerNum  INT,
  sku          INT,
  price        DECIMAL(10,2)
);
