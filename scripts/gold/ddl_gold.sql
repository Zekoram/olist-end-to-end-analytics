/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

USE OlistDataWarehouse;
GO

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

IF OBJECT_ID ('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER(ORDER BY customer_id) AS customer_key,
    customer_id,
    customer_unique_id, 
    customer_city,
    customer_state
FROM silver.olist_customers;
GO

-- =============================================================================
-- Create Dimension: gold.dim_sellers
-- =============================================================================

IF OBJECT_ID ('gold.dim_sellers', 'V') IS NOT NULL
    DROP VIEW gold.dim_sellers;
GO

CREATE VIEW gold.dim_sellers AS
SELECT
    ROW_NUMBER() OVER(ORDER BY seller_id) AS seller_key, 
    seller_id,
    seller_city,
    seller_state
FROM silver.olist_sellers;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER(ORDER BY p.product_id) AS product_key,
    p.product_id,
    CASE
        WHEN p.product_category_name = 'portateis_cozinha_e_preparadores_de_alimentos'  THEN 'small_kitchen_appliances_and_food_processors'
        WHEN p.product_category_name = 'pc_gamer' THEN 'pc_gamer'
        ELSE COALESCE(t.product_category_name_english, 'Unknown') 
    END AS product_category,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM silver.olist_products AS p
LEFT JOIN silver.olist_product_cat_translation AS t
    ON p.product_category_name = t.product_category_name;

-- =============================================================================
-- Create Fact Table: gold.fact_orders
-- =============================================================================

IF OBJECT_ID('gold.fact_orders', 'V') IS NOT NULL
    DROP VIEW gold.fact_orders;
GO

CREATE VIEW gold.fact_orders AS
SELECT
    f.order_id,
    c.customer_key,
    p.product_key,
    s.seller_key,
    ol.order_item_id,
    f.order_purchase_timestamp,
    f.order_approved_at,
    f.order_delivered_carrier_date,
    f.order_delivered_customer_date,
    f.order_estimated_delivery_date,
    ol.shipping_limit_date,
    ol.price,
    ol.freight_value,
    op.payment_value
FROM silver.olist_orders AS f
INNER JOIN silver.olist_order_items AS ol
    ON f.order_id = ol.order_id
INNER JOIN silver.olist_order_payments AS op
    ON f.order_id = op.order_id
LEFT JOIN gold.dim_customers AS c
    ON f.customer_id = c.customer_id
LEFT JOIN gold.dim_products AS p
    ON ol.product_id = p.product_id
LEFT JOIN gold.dim_sellers AS s
    ON ol.seller_id = s.seller_id;

-- =============================================================================
-- Create Fact Table: gold.fact_reviews
-- =============================================================================

IF OBJECT_ID('gold.fact_reviews', 'V') IS NOT NULL
    DROP VIEW gold.fact_reviews;
GO

CREATE VIEW gold.fact_reviews AS
SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date, 
    review_answer_timestamp
FROM silver.olist_order_reviews;









