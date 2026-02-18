/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

USE OlistDataWarehouse;
GO

-- ====================================================================
-- Checking 'silver.olist_customer'
-- ====================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    customer_id,
    COUNT(*)
FROM silver.olist_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;
GO

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    customer_city
FROM silver.olist_customers
WHERE customer_city != TRIM(customer_city);
GO

-- Data Standardization & Consistency
SELECT DISTINCT
    customer_state
FROM silver.olist_customers;
GO

-- ====================================================================
-- Checking 'silver.olist_order_reviews'
-- ====================================================================
-- Check for Duplicates in Primary Key
-- Expectation: No Results

SELECT
    review_id,
    order_id,
    COUNT(*) AS cnt
FROM silver.olist_order_reviews
GROUP BY review_id, order_id
HAVING COUNT(*) > 1;
GO

-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT
    review_comment_message
FROM silver.olist_order_reviews
WHERE review_comment_message != TRIM(review_comment_message);
GO

-- Check for NULLs or Negative Values in Score
-- Expectation: No Results

SELECT
    CAST(review_score AS INT) AS review_score
FROM silver.olist_order_reviews
WHERE TRY_CAST(review_score AS INT) < 0
   OR review_score IS NULL;

-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT
    review_creation_date,
    review_answer_timestamp
FROM silver.olist_order_reviews
WHERE review_creation_date IS NULL
   OR review_creation_date < '1900-01-01'
   OR review_creation_date > '2050-01-01'
   OR review_answer_timestamp IS NULL
   OR review_answer_timestamp < review_creation_date;

-- ====================================================================
-- Checking 'silver.olist_orders'
-- ====================================================================

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT
    order_id,
    COUNT(*)
FROM silver.olist_orders
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;
GO

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
    order_status
FROM silver.olist_orders
WHERE order_status != TRIM(order_status);
GO

-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM silver.olist_orders
WHERE order_purchase_timestamp IS NULL
   OR order_approved_at IS NULL
   OR order_delivered_carrier_date IS NULL
   OR order_delivered_customer_date IS NULL
   OR order_estimated_delivery_date IS NULL;

-- ====================================================================
-- Checking 'silver.olist_order_items'
-- ====================================================================

-- Check for Duplicates in Primary Key
-- Expectation: No Results

SELECT
    order_id,
    order_item_id,
    COUNT(*)
FROM silver.olist_order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
    CAST(price AS VARCHAR) AS price,
    CAST(freight_value AS VARCHAR) AS freight_value
FROM silver.olist_order_items
WHERE TRY_CAST(price AS VARCHAR) != TRIM(CAST(price AS VARCHAR)) 
    OR TRY_CAST(freight_value AS VARCHAR) != TRIM(CAST(freight_value AS VARCHAR));
GO

-- Check for NULLs or Negative Values in Price & Freight Value
-- Expectation: No Results
SELECT
    price,
    freight_value
FROM silver.olist_order_items
WHERE price < 0
    OR price IS NULL
    OR freight_value < 0
    OR freight_value IS NULL;
GO


-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT
    shipping_limit_date
FROM silver.olist_order_items
WHERE shipping_limit_date IS NULL
   OR shipping_limit_date < '1901-01-01'
   OR shipping_limit_date > '2050-01-01';

-- ====================================================================
-- Checking 'silver.olist_order_payments'
-- ====================================================================

-- Check for Duplicates in Primary Key
-- Expectation: No Results
SELECT
    order_id,
    payment_sequential,
    COUNT(*)
FROM silver.olist_order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;
GO

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
    CAST(payment_installments AS VARCHAR) AS payment_installments,
    CAST(payment_value AS VARCHAR) AS payment_value,
    payment_type
FROM silver.olist_order_payments
WHERE TRY_CAST(payment_installments AS VARCHAR) != TRIM(CAST(payment_installments AS VARCHAR)) 
    OR TRY_CAST(payment_value AS VARCHAR) != TRIM(CAST(payment_value AS VARCHAR))
    OR payment_type != TRIM(payment_type);
GO

-- Check for NULLs or Negative Values in Payment Installments & Value
-- Expectation: No Results
SELECT
    payment_installments,
    payment_value
FROM silver.olist_order_payments
WHERE payment_installments < 0
    OR payment_installments IS NULL
    OR payment_value < 0
    OR payment_value IS NULL;
GO

-- ====================================================================
-- Checking 'silver.olist_sellers'
-- ====================================================================

-- Check for Duplicates in Primary Key
-- Expectation: No Results
SELECT
    seller_id,
    COUNT(*)
FROM silver.olist_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1 OR seller_id IS NULL;
GO

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
    seller_state
FROM silver.olist_sellers
WHERE seller_state != TRIM(seller_state);
GO

-- Data Standardization & Consistency
SELECT DISTINCT
    seller_state
FROM silver.olist_sellers;
GO

-- ====================================================================
-- Checking 'silver.olist_products'
-- ====================================================================

-- Check for Duplicates in Primary Key
-- Expectation: No Results
SELECT
    product_id,
    COUNT(*)
FROM silver.olist_products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;
GO

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
    product_category_name
FROM silver.olist_products
WHERE product_category_name != TRIM(product_category_name);
GO

-- Check for NULLs or Negative Values in Price & Freight Value
SELECT
    product_category_name,
    product_name_length,
    product_description_length,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM silver.olist_products
WHERE product_weight_g < 0 OR product_weight_g IS NULL
    OR product_name_length < 0 OR product_name_length IS NULL
    OR product_description_length < 0 OR product_description_length IS NULL
    OR product_length_cm < 0 OR product_length_cm IS NULL
    OR product_height_cm < 0 OR product_height_cm IS NULL
    OR product_width_cm < 0 OR product_width_cm IS NULL
GO

-- Data Standardization & Consistency
SELECT DISTINCT
    product_category_name
FROM silver.olist_products;
GO

-- ====================================================================
-- Checking 'silver.olist_product_cat_translation'
-- ====================================================================

-- Check for Duplicates 
-- Expectation: No Results
SELECT
    product_category_name,
    product_category_name_english,
    COUNT(*)
FROM silver.olist_product_cat_translation
GROUP BY product_category_name, product_category_name_english
HAVING COUNT(*) > 1 OR product_category_name IS NULL OR product_category_name_english IS NULL;
GO

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
    product_category_name,
    product_category_name_english
FROM silver.olist_product_cat_translation
WHERE product_category_name != TRIM(product_category_name)
    OR product_category_name_english != TRIM(product_category_name_english);
GO

-- Data Standardization & Consistency
SELECT DISTINCT
    product_category_name,
    product_category_name_english
FROM silver.olist_product_cat_translation

-- ====================================================================
-- Checking 'silver.olist_geolocation'
-- ====================================================================

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT
    geolocation_state
FROM silver.olist_geolocation
WHERE geolocation_state != TRIM(geolocation_state)
GO

-- Check for NULLs in Geolocation Lat & Long 
-- Expectation: No Results
SELECT
    geolocation_lat,
    geolocation_lng
FROM silver.olist_geolocation
WHERE geolocation_lat IS NULL OR geolocation_lng IS NULL;
GO

-- Data Standardization & Consistency
SELECT DISTINCT
    geolocation_state
FROM silver.olist_geolocation;
GO