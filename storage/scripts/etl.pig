SET mapred.output.direct.NativeS3FileSystem false;
SET mapred.output.direct.EmrFileSystem false;

-- Product
ext_product = LOAD 'sales_staging.ext_product' USING org.apache.hive.hcatalog.pig.HCatLoader();

-- Sales
ext_sales = LOAD 'sales_staging.ext_sales' USING org.apache.hive.hcatalog.pig.HCatLoader();
sales_product = JOIN ext_sales BY (product_id), ext_product BY (id) PARALLEL 2;
fact_sales = FOREACH sales_product GENERATE ext_sales::id AS id, order_number AS order_number, customer_id AS customer_id, showroom_id AS showroom_id, product_id AS product_id, quantity AS quantity, discount AS discount, price*quantity AS amount, (price*quantity)- discount AS net_amount, delivered AS delivered, card_type AS card_type, card_number AS card_number, ext_sales::update_date AS update_date, ext_sales::create_date AS create_date, txn_date AS txn_date;
STORE fact_sales INTO 'sales_analytics.fact_sales' USING org.apache.hive.hcatalog.pig.HCatStorer();

-- Stocks
ext_stocks = LOAD 'sales_staging.ext_stocks' USING org.apache.hive.hcatalog.pig.HCatLoader();
stocks_product = JOIN ext_stocks BY (product_id), ext_product BY (id) PARALLEL 2;
fact_stocks = FOREACH stocks_product GENERATE ext_stocks::id AS id, showroom_id AS showroom_id, product_id AS product_id, quantity AS quantity, price*quantity AS stock_amount, ext_stocks::update_date AS update_date, ext_stocks::create_date AS create_date, stock_date AS stock_date;
STORE fact_stocks INTO 'sales_analytics.fact_stocks' USING org.apache.hive.hcatalog.pig.HCatStorer();
