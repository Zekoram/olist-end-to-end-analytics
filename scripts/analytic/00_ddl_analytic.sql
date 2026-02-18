/*
==============================================================================================================
DDL Script: Create Analytics Tables
==============================================================================================================
Script Purpose:
    This script creates tables in the 'analytic' schema, dropping existing tables 
    if they already exist

Usage:
    These tables are used for analytical queries, performance-efficient reporting, and downstream analysis.
===============================================================================================================
*/

USE OlistDataWarehouse;
GO

IF OBJECT_ID('analytic.dim_customers', 'U') IS NOT NULL
	DROP TABLE analytic.dim_customers;
GO

CREATE TABLE analytic.dim_customers(
	customer_key INT,
	customer_id NVARCHAR(50),
	customer_unique_id NVARCHAR(50),
	customer_city NVARCHAR(50),
	customer_state NVARCHAR(50)
);
GO

IF OBJECT_ID('analytic.dim_sellers', 'U') IS NOT NULL
	DROP TABLE analytic.dim_sellers;
GO

CREATE TABLE analytic.dim_sellers(
	seller_key INT,
	seller_id NVARCHAR(50),
	seller_city NVARCHAR(50),
	seller_state NVARCHAR(50)
);
GO

IF OBJECT_ID('analytic.dim_products', 'U') IS NOT NULL
	DROP TABLE analytic.dim_products;
GO

CREATE TABLE analytic.dim_products(
	product_key INT,
	product_id NVARCHAR(50),
	product_category NVARCHAR(50),
	product_name_length INT,
	product_description_length INT,
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT
);
GO

IF OBJECT_ID('analytic.fact_orders', 'U') IS NOT NULL
	DROP TABLE analytic.fact_orders;
GO

CREATE TABLE analytic.fact_orders(
	order_id NVARCHAR(50),
	customer_key INT,
	seller_key INT,
	product_key INT,
	order_item_id INT,
	order_purchase_timestamp DATETIME,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATE,
	order_delivered_customer_date DATE,
	order_estimated_delivery_date DATE,
	shipping_limit_date DATE,
	price FLOAT,
	freight_value FLOAT,
	payment_value FLOAT
);
GO

IF OBJECT_ID('analytic.fact_reviews', 'U') IS NOT NULL
	DROP TABLE analytic.fact_reviews;
GO

CREATE TABLE analytic.fact_reviews(
    review_id NVARCHAR(100),
    order_id NVARCHAR(100),
    review_score INT,
    review_creation_date DATE,      
    review_answer_timestamp DATETIME,    
);
GO

EXEC analytic.load_analytic;

SELECT TOP 10 * FROM analytic.fact_orders;

SELECT TOP 10 * FROM gold.fact_orders;