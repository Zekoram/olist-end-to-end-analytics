/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

USE OlistDataWarehouse;
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '========================================================================';
		PRINT 'LOADING SILVER LAYER';
		PRINT '========================================================================';

		PRINT '========================================================================';
		PRINT 'LOADING CRM Tables';
		PRINT '========================================================================';

		--Loading silver.olist_customers
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_customers';
		TRUNCATE TABLE silver.olist_customers;
		PRINT '>> Loading Data Info: silver.olist_customers';
		INSERT INTO silver.olist_customers(
			customer_id,
			customer_unique_id,
			customer_zip_code_prefix,
			customer_city,
			customer_state
		)
		SELECT
				customer_id,
				customer_unique_id,
				customer_zip_code_prefix,
				customer_city,
				customer_state
		FROM bronze.olist_customers;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading silver.olist_order_reviews
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_order_reviews';
		TRUNCATE TABLE silver.olist_order_reviews
		PRINT '>> Loading Data Info: silver.olist_order_reviews';
		INSERT INTO silver.olist_order_reviews(
			review_id,
			order_id,
			review_score,
			review_comment_title,
			review_comment_message,
			review_creation_date,
			review_answer_timestamp
		)
		SELECT 
			REPLACE(review_id, '"', '') AS review_id,
			REPLACE(order_id, '"', '') AS order_id,
			CAST(REPLACE(review_score, '"', '') AS INT) AS review_score,
			NULLIF(REPLACE(review_comment_title, '"', ''), '') AS review_comment_title,
			NULLIF(REPLACE(review_comment_message, '"', ''), '') AS review_comment_message,
			CAST(REPLACE(review_creation_date, '"', '') AS DATE) AS review_creation_date,
			CAST(REPLACE(review_answer_timestamp, '"', '') AS DATETIME) AS review_answer_timestamp
		FROM bronze.olist_order_reviews;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		PRINT '========================================================================';
		PRINT 'LOADING ERP Tables';
		PRINT '========================================================================';

		--Loading silver.olist_orders
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_orders';
		TRUNCATE TABLE silver.olist_orders
		PRINT '>> Loading Data Info: silver.olist_orders';
		INSERT INTO silver.olist_orders(
			order_id,
			customer_id,
			order_status,
			order_purchase_timestamp,
			order_approved_at,
			order_delivered_carrier_date,
			order_delivered_customer_date,
			order_estimated_delivery_date
		)
		SELECT
			REPLACE(order_id, '"', '') AS order_id,
			REPLACE(customer_id, '"', '') AS customer_id,
			REPLACE(order_status, '"', '') AS order_status,
			CAST(order_purchase_timestamp AS DATETIME) AS order_purchase_timestamp,
			CAST(order_approved_at AS DATETIME) AS order_approved_at,
			CAST(order_delivered_carrier_date AS DATE) AS order_delivered_carrier_date,
			CAST(order_delivered_customer_date AS DATE) AS order_delivered_customer_date,
			CAST(order_estimated_delivery_date AS DATE) AS order_estimated_delivery_date
		FROM bronze.olist_orders;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading silver.olist_order_items
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_order_items';
		TRUNCATE TABLE silver.olist_order_items
		PRINT '>> Loading Data Info: silver.olist_order_items';
		INSERT INTO silver.olist_order_items(
			order_id,
			order_item_id,
			product_id,
			seller_id,
			shipping_limit_date,
			price,
			freight_value
		)
		SELECT
			REPLACE(order_id, '"', '') AS order_id,
			order_item_id,
			REPLACE(product_id, '"', '') AS product_id,
			REPLACE(seller_id, '"', '') AS seller_id,
			CAST(shipping_limit_date AS DATE) AS shipping_limit_date,
			price,
			freight_value
		FROM bronze.olist_order_items;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading silver.olist_order_payments
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_order_payments';
		TRUNCATE TABLE silver.olist_order_payments;
		PRINT '>> Loading Data Info: silver.olist_order_payments';
		INSERT INTO silver.olist_order_payments(
			order_id,
			payment_sequential,
			payment_type,
			payment_installments,
			payment_value
		)
		SELECT
			REPLACE(order_id, '"', '') AS order_id,
			payment_sequential,
			payment_type,
			payment_installments,
			payment_value
		FROM bronze.olist_order_payments
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading silver.olist_sellers
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_sellers';
		TRUNCATE TABLE silver.olist_sellers
		PRINT '>> Loading Data Info: silver.olist_sellers';
		INSERT INTO silver.olist_sellers(
			seller_id,
			seller_zip_code_prefix,
			seller_state,
			seller_city
		)
		SELECT
			REPLACE(seller_id, '"', '') AS seller_id,
			REPLACE(seller_zip_code_prefix, '"', '') AS seller_zip_code_prefix,
			UPPER(
				CASE
					WHEN LEN(REPLACE(seller_state, '"', '')) = 2 THEN seller_state
					ELSE RIGHT(REPLACE(seller_state, '"', ''), 2)
				END
				) AS seller_state,
			seller_city
		FROM bronze.olist_sellers
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading silver.olist_products
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_products';
		TRUNCATE TABLE silver.olist_products;
		PRINT '>> Loading Data Info: silver.olist_products';

		INSERT INTO silver.olist_products (
			product_id,
			product_category_name,
			product_name_length,
			product_description_length,
			product_photos_qty,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		)
		SELECT
			REPLACE(product_id, '"', '') AS product_id,
			NULLIF(product_category_name, '') AS product_category_name,
			TRY_CAST(NULLIF(product_name_length, '') AS INT) AS product_name_length,
			TRY_CAST(NULLIF(product_desctiption_lenght, '') AS INT) AS product_description_length,
			TRY_CAST(NULLIF(product_photos_qty, '') AS INT) AS product_photos_qty,
			TRY_CAST(NULLIF(product_weight_g, '') AS INT) AS product_weight_g,
			TRY_CAST(NULLIF(product_length_cm, '') AS INT) AS product_length_cm,
			TRY_CAST(NULLIF(product_height_cm, '') AS INT) AS product_height_cm,
			TRY_CAST(NULLIF(product_width_cm, '') AS INT) AS product_width_cm
		FROM bronze.olist_products
		WHERE NOT (
			   NULLIF(product_category_name, '') IS NULL
		   AND NULLIF(product_name_length, '') IS NULL
		   AND NULLIF(product_desctiption_lenght, '') IS NULL
		   AND NULLIF(product_weight_g, '') IS NULL
		   AND NULLIF(product_length_cm, '') IS NULL
		   AND NULLIF(product_height_cm, '') IS NULL
		   AND NULLIF(product_width_cm, '') IS NULL
		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		PRINT '========================================================================';
		PRINT 'LOADING REFERENCE DATA Tables';
		PRINT '========================================================================';

		--Loading silver.olist_product_cat_translation
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_product_cat_translation';
		TRUNCATE TABLE silver.olist_product_cat_translation
		PRINT '>> Loading Data Info: silver.olist_product_cat_translation';
		INSERT INTO silver.olist_product_cat_translation(
			product_category_name,
			product_category_name_english
		)
		SELECT
			product_category_name,
			product_category_name_english
		FROM bronze.olist_product_cat_translation;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading silver.olist_geolocation
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.olist_geolocation';
		TRUNCATE TABLE silver.olist_geolocation
		PRINT '>> Loading Data Info: silver.olist_geolocation';
		INSERT INTO silver.olist_geolocation(
			geolocation_zip_code_prefix,
			geolocation_lat,
			geolocation_lng,
			geolocation_city,
			geolocation_state
		)
		SELECT
			REPLACE(geolocation_zip_code_prefix, '"', '') AS geolocation_zip_code_prefix,
			geolocation_lat,
			geolocation_lng,
			geolocation_city,
			UPPER(
				CASE
					WHEN LEN(TRIM(geolocation_state)) = 2 THEN geolocation_state
					ELSE RIGHT(TRIM(geolocation_state), 2)
				END
			) AS geolocation_state
		FROM bronze.olist_geolocation;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
		PRINT '- Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS VARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END