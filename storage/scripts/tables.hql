CREATE DATABASE sales_staging;
CREATE DATABASE sales_analytics;

-- Dates
CREATE EXTERNAL TABLE IF NOT EXISTS sales_staging.ext_dates (
  year_number INT,
  month_number INT,
  day_of_year_number INT,
  day_of_month_number INT,
  day_of_week_number INT,
  week_of_year_number INT,
  day_name VARCHAR(20),
  month_name VARCHAR (20),
  quarter_number INT,
  quarter_name VARCHAR(2),
  year_quarter_name VARCHAR(10),
  weekend_ind VARCHAR(1),
  days_in_month_qty INT,
  date_sk INT,
  day_desc VARCHAR(10),
  week_sk INT,
  day_date DATE,
  week_name VARCHAR(10),
  week_of_month_number INT,
  week_of_month_name VARCHAR(10),
  month_sk INT,
  quarter_sk INT,
  year_sk INT,
  year_sort_number VARCHAR(4),
  day_of_week_sort_name VARCHAR(10)
) 
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/datasets/dates/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS sales_analytics.dim_date(
  year_number INT,
  month_number INT,
  day_of_year_number INT,
  day_of_month_number INT,
  day_of_week_number INT,
  week_of_year_number INT,
  day_name VARCHAR(20),
  month_name VARCHAR (20),
  quarter_number INT,
  quarter_name VARCHAR(2),
  year_quarter_name VARCHAR(10),
  weekend_ind VARCHAR(1),
  days_in_month_qty INT,
  date_sk INT,
  day_desc VARCHAR(10),
  week_sk INT,
  day_date DATE,
  week_name VARCHAR(10),
  week_of_month_number INT,
  week_of_month_name VARCHAR(10),
  month_sk INT,
  quarter_sk INT,
  year_sk INT,
  year_sort_number VARCHAR(4),
  day_of_week_sort_name VARCHAR(10)
)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

INSERT OVERWRITE TABLE sales_analytics.dim_date SELECT * FROM sales_staging.ext_dates;
ANALYZE TABLE sales_analytics.dim_date COMPUTE STATISTICS FOR COLUMNS;


-- Showroom
CREATE EXTERNAL TABLE IF NOT EXISTS sales_staging.ext_showroom (
  id INT,
  code VARCHAR(40),
  name VARCHAR(50),
  operation_date DATE,
  staff_count INT,
  country VARCHAR(50),
  state VARCHAR(50),
  address VARCHAR(50),
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/datasets/showroom/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS sales_analytics.dim_showroom(
  id INT,
  code VARCHAR(40),
  name VARCHAR(50),
  operation_date DATE,
  staff_count INT,
  country VARCHAR(50),
  state VARCHAR(50),
  address VARCHAR(50),
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

INSERT OVERWRITE TABLE sales_analytics.dim_showroom SELECT * FROM sales_staging.ext_showroom;
ANALYZE TABLE sales_analytics.dim_showroom COMPUTE STATISTICS FOR COLUMNS;


-- Customer
CREATE EXTERNAL TABLE IF NOT EXISTS sales_staging.ext_customer (
  id INT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  gender VARCHAR(50),
  dob DATE,
  company VARCHAR(50),
  job VARCHAR(50),
  email VARCHAR(50),
  country VARCHAR(50),
  state VARCHAR(50),
  address VARCHAR(50),
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/datasets/customer/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS sales_analytics.dim_customer(
  id INT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  gender VARCHAR(50),
  dob DATE,
  company VARCHAR(50),
  job VARCHAR(50),
  email VARCHAR(50),
  country VARCHAR(50),
  state VARCHAR(50),
  address VARCHAR(50),
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

INSERT OVERWRITE TABLE sales_analytics.dim_customer SELECT * FROM sales_staging.ext_customer;
ANALYZE TABLE sales_analytics.dim_customer COMPUTE STATISTICS FOR COLUMNS;


-- Product
CREATE EXTERNAL TABLE IF NOT EXISTS sales_staging.ext_product (
  id INT,
  code VARCHAR(50),
  category VARCHAR(6),
  make VARCHAR(50),
  model VARCHAR(50),
  year VARCHAR(50),
  color VARCHAR(50),
  price INT,
  currency VARCHAR(50),
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/datasets/product/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS sales_analytics.dim_product(
  id INT,
  code VARCHAR(50),
  category VARCHAR(6),
  make VARCHAR(50),
  model VARCHAR(50),
  year VARCHAR(50),
  color VARCHAR(50),
  price INT,
  currency VARCHAR(50),
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

INSERT OVERWRITE TABLE sales_analytics.dim_product SELECT * FROM sales_staging.ext_product;
ANALYZE TABLE sales_analytics.dim_product COMPUTE STATISTICS FOR COLUMNS;


-- Sales
CREATE EXTERNAL TABLE IF NOT EXISTS sales_staging.ext_sales (
  id INT,
  order_number VARCHAR(50),
  customer_id INT,
  showroom_id INT,
  product_id INT,
  quantity INT,
  discount INT,
  amount INT,
  delivered VARCHAR(50),
  card_type VARCHAR(50),
  card_number VARCHAR(50),
  txn_date DATE,
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/datasets/sales/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS sales_analytics.fact_sales (
  id INT,
  order_number VARCHAR(50),
  customer_id INT,
  showroom_id INT,
  product_id INT,
  quantity INT,
  discount INT,
  amount INT,
  net_amount INT,
  delivered VARCHAR(50),
  card_type VARCHAR(50),
  card_number VARCHAR(50),
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
PARTITIONED BY (txn_date DATE)
STORED AS ORC 
TBLPROPERTIES ("orc.compress"="SNAPPY");


-- Stocks
CREATE EXTERNAL TABLE IF NOT EXISTS sales_staging.ext_stocks (
  id INT,
  showroom_id INT,
  product_id INT,
  quantity INT,
  stock_date DATE,
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/datasets/stocks/'
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS sales_analytics.fact_stocks (
  id INT,
  showroom_id INT,
  product_id INT,
  quantity INT,
  stock_amount INT,
  update_date TIMESTAMP,
  create_date TIMESTAMP
)
PARTITIONED BY (stock_date DATE)
STORED AS ORC 
TBLPROPERTIES ("orc.compress"="SNAPPY");
