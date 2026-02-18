/*
====================================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
====================================================================================================
Script Purpose:
	This stored procedure loads data into the 'bronze' schema from the external CSV files.
	It performs the following actions:
	- Truncate the bronze tables before loading data.
	- Use the command 'BULK INSERT' to load data from CSV files to bronze tables.
Parameters:
	None.
		This store procedure does not acccept any parameter or return any values.
Usage Example:
	EXEC bronze.load_bronze;
====================================================================================================
*/

USE OlistDataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=======================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=======================================================================';

		PRINT '=======================================================================';
		PRINT 'Loading CRM Tables';
		PRINT '=======================================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_customers';
		TRUNCATE TABLE bronze.olist_customers;
		PRINT '>> Insering Data Info: bronze.olist_customers';
		BULK INSERT bronze.olist_customers
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_customers_dataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_order_reviews';
		TRUNCATE TABLE bronze.olist_order_reviews;
		PRINT '>> Insering Data Info: bronze.olist_order_reviews';
		BULK INSERT bronze.olist_order_reviews
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_order_reviews_cleaned.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		PRINT '=======================================================================';
		PRINT 'Loading ERP Tables';
		PRINT '=======================================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_order_items';
		TRUNCATE TABLE bronze.olist_order_items;
		PRINT '>> Insering Data Info: bronze.olist_order_items';
		BULK INSERT bronze.olist_order_items
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_order_items_dataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_order_payments';
		TRUNCATE TABLE bronze.olist_order_payments;
		PRINT '>> Insering Data Info: bronze.olist_order_payments';
		BULK INSERT bronze.olist_order_payments
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_order_payments_dataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_orders';
		TRUNCATE TABLE bronze.olist_orders;
		PRINT '>> Insering Data Info: bronze.olist_orders';
		BULK INSERT bronze.olist_orders
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_orders_dataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_sellers';
		TRUNCATE TABLE bronze.olist_sellers;
		PRINT '>> Insering Data Info: bronze.olist_sellers';
		BULK INSERT bronze.olist_sellers
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_sellers_dataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_products';
		TRUNCATE TABLE bronze.olist_products;
		PRINT '>> Insering Data Info: bronze.olist_products';
		BULK INSERT bronze.olist_products
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_products_dataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		PRINT '=======================================================================';
		PRINT 'Loading Reference Data Tables';
		PRINT '=======================================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_geolocation';
		TRUNCATE TABLE bronze.olist_geolocation;
		PRINT '>> Insering Data Info: bronze.olist_geolocation';
		BULK INSERT bronze.olist_geolocation
		FROM 'D:\Brazilian E-commerce DA Project\datasets\olist_geolocation_dataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.olist_product_cat_translation';
		TRUNCATE TABLE bronze.olist_product_cat_translation;
		PRINT '>> Insering Data Info: bronze.olist_product_cat_translation';
		BULK INSERT bronze.olist_product_cat_translation
		FROM 'D:\Brazilian E-commerce DA Project\datasets\product_category_name_translation.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0A',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + ' seconds';
		PRINT '>> --------------------';

		SET @batch_end_time = GETDATE();
		PRINT '=======================================================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS VARCHAR) + ' seconds';
		PRINT '=======================================================================';
	END TRY
	BEGIN CATCH
		PRINT '=======================================================================';
		PRINT 'Error Occured During Loading Bronze Layer';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=======================================================================';
	END CATCH
END

