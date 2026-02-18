/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

USE OlistDataWarehouse;
GO

-- Retrieve a list of unique states from which customers originate
SELECT DISTINCT
    customer_state
FROM analytic.dim_customers
ORDER BY customer_state;

-- Retrieve a list of unique states from which sellers originate
SELECT DISTINCT
    seller_state
FROM analytic.dim_sellers
ORDER BY seller_state;

-- Retrieve a list of unique categories
SELECT DISTINCT
    product_category
FROM analytic.dim_products
ORDER BY product_category;

