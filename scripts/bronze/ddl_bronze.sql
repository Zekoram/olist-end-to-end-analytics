/*
==============================================================================
DDL Script: Create Bronze Layer
==============================================================================
Purpose:
	- The purpose of this script is to create tables in the 'bronze' schema.
	- It will first drop the table if it already exist.
	- Run this script to re-define the DDL structure of the 'bronze' tables.
==============================================================================
*/

USE OlistDataWarehouse;
GO

IF OBJECT_ID('bronze.olist_customers', 'U') IS NOT NULL
	DROP TABLE bronze.olist_customers;
GO

CREATE TABLE bronze.olist_customers(
	customer_id NVARCHAR(50),
	customer_unique_id NVARCHAR(50),
	customer_zip_code_prefix INT,
	customer_city NVARCHAR(50),
	customer_state NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.olist_geolocation', 'U') IS NOT NULL
	DROP TABLE bronze.olist_geolocation;
GO

CREATE TABLE bronze.olist_geolocation(
	geolocation_zip_code_prefix NVARCHAR(50),
	geolocation_lat FLOAT,
	geolocation_lng FLOAT,
	geolocation_city NVARCHAR(50),
	geolocation_state NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.olist_order_items', 'U') IS NOT NULL
	DROP TABLE bronze.olist_order_items;
GO

CREATE TABLE bronze.olist_order_items(
	order_id NVARCHAR(50),
	order_item_id INT,
	product_id NVARCHAR(50),
	seller_id NVARCHAR(50),
	shipping_limit_date NVARCHAR(50),
	price FLOAT,
	freight_value FLOAT
);
GO

IF OBJECT_ID('bronze.olist_order_payments', 'U') IS NOT NULL
	DROP TABLE bronze.olist_order_payments;
GO

CREATE TABLE bronze.olist_order_payments(
	order_id NVARCHAR(50),
	payment_sequential INT,
	payment_type NVARCHAR(50),
	payment_installments INT,
	payment_value FLOAT
);
GO

IF OBJECT_ID('bronze.olist_order_reviews', 'U') IS NOT NULL
	DROP TABLE bronze.olist_order_reviews;
GO

CREATE TABLE bronze.olist_order_reviews(
    review_id NVARCHAR(100),
    order_id NVARCHAR(100),
    review_score NVARCHAR(50),
    review_comment_title NVARCHAR(250),      -- MAX instead of 50
    review_comment_message NVARCHAR(MAX),    -- MAX instead of 250
    review_creation_date NVARCHAR(100),      -- 100 instead of 50
    review_answer_timestamp NVARCHAR(100)    -- 100 instead of 50
);
GO

IF OBJECT_ID('bronze.olist_orders', 'U') IS NOT NULL
	DROP TABLE bronze.olist_orders;
GO

CREATE TABLE bronze.olist_orders(
	order_id NVARCHAR(50),
	customer_id NVARCHAR(50),
	order_status NVARCHAR(50),
	order_purchase_timestamp NVARCHAR(50),
	order_approved_at NVARCHAR(50),
	order_delivered_carrier_date NVARCHAR(50),
	order_delivered_customer_date NVARCHAR(50),
	order_estimated_delivery_date NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.olist_products', 'U') IS NOT NULL
	DROP TABLE bronze.olist_products;
GO

CREATE TABLE bronze.olist_products(
	product_id NVARCHAR(50),
	product_category_name NVARCHAR(50),
	product_name_length FLOAT,
	product_desctiption_lenght FLOAT,
	product_photos_qty FLOAT,
	product_weight_g FLOAT,
	product_length_cm FLOAT,
	product_height_cm FLOAT,
	product_width_cm FLOAT
);
GO

IF OBJECT_ID('bronze.olist_sellers', 'U') IS NOT NULL
	DROP TABLE bronze.olist_sellers;
GO

CREATE TABLE bronze.olist_sellers(
	seller_id NVARCHAR(50),
	seller_zip_code_prefix NVARCHAR(50),
	seller_city NVARCHAR(50),
	seller_state NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.olist_product_cat_translation', 'U') IS NOT NULL
	DROP TABLE bronze.olist_prdoduct_cat_translation;
GO

CREATE TABLE bronze.olist_product_cat_translation(
	product_category_name NVARCHAR(50),
	product_category_name_english NVARCHAR(50)
);
GO
