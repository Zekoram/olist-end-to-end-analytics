/*
===========================================================================================
Stored Procedure: Load Analytic Layer 
===========================================================================================
Script Purpose:
    This stored procedure loads data into the Analytics schema tables from the Gold layer.
	It materializes business-ready data to support exploratory data analysis (EDA) 
	and advanced analytics.
	Actions Performed:
		- Truncates Analytics tables.
		- Inserts prepared data from Gold views into Analytics tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Analytics.load_analytics;
============================================================================================
*/

USE OlistDataWarehouse;
GO

CREATE OR ALTER PROCEDURE analytic.load_analytic AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '========================================================================';
		PRINT 'LOADING Analytic Layer';
		PRINT '========================================================================';

		PRINT '========================================================================';
		PRINT 'LOADING DIM Tables';
		PRINT '========================================================================';

		--Loading analytic.dim_customers
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: analytic.dim_customers';
		TRUNCATE TABLE analytic.dim_customers;
		PRINT '>> Loading Data Info: analytic.dim_customers';
		INSERT INTO analytic.dim_customers(
			customer_key,
			customer_id,
			customer_unique_id,
			customer_city,
			customer_state
		)
		SELECT
				customer_key,
				customer_id,
				customer_unique_id,
				customer_city,
				customer_state
		FROM gold.dim_customers;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading analytic.dim_sellers
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: analytic.dim_sellers';
		TRUNCATE TABLE analytic.dim_sellers
		PRINT '>> Loading Data Info: analytic.dim_sellers';
		INSERT INTO analytic.dim_sellers(
			seller_key,
			seller_id,
			seller_city,
			seller_state
		)
		SELECT 
			seller_key,
			seller_id,
			seller_city,
			seller_state
		FROM gold.dim_sellers;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading analytic.dim_products
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: analytic.dim_products';
		TRUNCATE TABLE analytic.dim_products
		PRINT '>> Loading Data Info: analytic.dim_products';
		INSERT INTO analytic.dim_products(
			product_key,
			product_id,
			product_category,
			product_name_length,
			product_description_length,
			product_photos_qty,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		)
		SELECT 
			product_key,
			product_id,
			product_category,
			product_name_length,
			product_description_length,
			product_photos_qty,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		FROM gold.dim_products;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		PRINT '========================================================================';
		PRINT 'LOADING FACT Tables';
		PRINT '========================================================================';

		--Loading analytic.fact_orders
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: analytic.fact_orders';
		TRUNCATE TABLE analytic.fact_orders
		PRINT '>> Loading Data Info: analytic.fact_orders';
		INSERT INTO analytic.fact_orders(
			order_id,
			customer_key,
			seller_key,
			product_key,
			order_item_id,
			order_purchase_timestamp,
			order_approved_at,
			order_delivered_carrier_date,
			order_delivered_customer_date,
			order_estimated_delivery_date,
			shipping_limit_date,
			price,
			freight_value,
			payment_value
		)
		SELECT
			order_id,
			customer_key,
			seller_key,
			product_key,
			order_item_id,
			order_purchase_timestamp,
			order_approved_at,
			order_delivered_carrier_date,
			order_delivered_customer_date,
			order_estimated_delivery_date,
			shipping_limit_date,
			price,
			freight_value,
			payment_value
		FROM gold.fact_orders;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------------';

		--Loading analytic.fact_reviews
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: analytic.fact_reviews';
		TRUNCATE TABLE analytic.fact_reviews
		PRINT '>> Loading Data Info: analytic.fact_reviews';
		INSERT INTO analytic.fact_reviews(
			review_id,
			order_id,
			review_score,
			review_creation_date,
			review_answer_timestamp
		)
		SELECT
			review_id,
			order_id,
			review_score,
			review_creation_date,
			review_answer_timestamp
		FROM gold.fact_reviews;
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


