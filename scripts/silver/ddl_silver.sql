/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

USE OlistDataWarehouse;
GO

IF OBJECT_ID('silver.olist_customers', 'U') IS NOT NULL
	DROP TABLE silver.olist_customers;
GO

CREATE TABLE silver.olist_customers(
	customer_id NVARCHAR(50),
	customer_unique_id NVARCHAR(50),
	customer_zip_code_prefix INT,
	customer_city NVARCHAR(50),
	customer_state NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_geolocation', 'U') IS NOT NULL
	DROP TABLE silver.olist_geolocation;
GO

CREATE TABLE silver.olist_geolocation(
	geolocation_zip_code_prefix INT,
	geolocation_lat FLOAT,
	geolocation_lng FLOAT,
	geolocation_city VARCHAR(50),
	geolocation_state VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_order_items', 'U') IS NOT NULL
	DROP TABLE silver.olist_order_items;
GO

CREATE TABLE silver.olist_order_items(
	order_id NVARCHAR(50),
	order_item_id INT,
	product_id NVARCHAR(50),
	seller_id NVARCHAR(50),
	shipping_limit_date DATE,
	price FLOAT,
	freight_value FLOAT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_order_payments', 'U') IS NOT NULL
	DROP TABLE silver.olist_order_payments;
GO

CREATE TABLE silver.olist_order_payments(
	order_id NVARCHAR(50),
	payment_sequential INT,
	payment_type VARCHAR(50),
	payment_installments INT,
	payment_value FLOAT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_order_reviews', 'U') IS NOT NULL
	DROP TABLE silver.olist_order_reviews;
GO

CREATE TABLE silver.olist_order_reviews(
    review_id NVARCHAR(100),
    order_id NVARCHAR(100),
    review_score INT,
    review_comment_title NVARCHAR(250),      -- MAX instead of 50
    review_comment_message NVARCHAR(MAX),    -- MAX instead of 250
    review_creation_date DATE,      -- 100 instead of 50
    review_answer_timestamp DATETIME,    -- 100 instead of 50
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_orders', 'U') IS NOT NULL
	DROP TABLE silver.olist_orders;
GO

CREATE TABLE silver.olist_orders(
	order_id NVARCHAR(50),
	customer_id NVARCHAR(50),
	order_status VARCHAR(50),
	order_purchase_timestamp DATETIME,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATE,
	order_delivered_customer_date DATE,
	order_estimated_delivery_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_products', 'U') IS NOT NULL
	DROP TABLE silver.olist_products;
GO

CREATE TABLE silver.olist_products(
	product_id NVARCHAR(50),
	product_category_name VARCHAR(50),
	product_name_length INT,
	product_desctiption_lenght INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_sellers', 'U') IS NOT NULL
	DROP TABLE silver.olist_sellers;
GO

CREATE TABLE silver.olist_sellers(
	seller_id NVARCHAR(50),
	seller_zip_code_prefix INT,
	seller_city VARCHAR(50),
	seller_state VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.olist_product_cat_translation', 'U') IS NOT NULL
	DROP TABLE silver.olist_product_cat_translation;
GO

CREATE TABLE silver.olist_product_cat_translation(
	product_category_name NVARCHAR(50),
	product_category_name_english NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
