/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

USE OlistDataWarehouse;
GO

SELECT * FROM analytic.fact_orders;

-- Analyse sales performance over time
-- Quick Date Functions
SELECT
    order_year,
    order_month,
    SUM(payment_value) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT product_key) AS total_products,
    COUNT(*) AS total_quantity
FROM (
    SELECT DISTINCT
        order_id,
        order_item_id,
        customer_key,
        product_key,
        YEAR(order_purchase_timestamp) AS order_year,
        MONTH(order_purchase_timestamp) AS order_month,
        payment_value
    FROM analytic.fact_orders
) t
GROUP BY order_year, order_month
ORDER BY order_year, order_month

-- DATETRUNC()

SELECT
    order_month,
    SUM(payment_value) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT product_key) AS total_products,
    COUNT(*) AS total_quantity
FROM (
    SELECT DISTINCT
        order_id,
        order_item_id,
        customer_key,
        product_key,
        DATETRUNC(MONTH, order_purchase_timestamp) AS order_month,
        payment_value
    FROM analytic.fact_orders
) t
GROUP BY order_month
ORDER BY order_month

-- FORMAT()
SELECT
    order_date,
    SUM(payment_value) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT product_key) AS total_products,
    COUNT(*) AS total_quantity
FROM (
    SELECT DISTINCT
        order_id,
        order_item_id,
        customer_key,
        product_key,
        FORMAT(order_purchase_timestamp, 'yyyy-MMM') AS order_date,
        payment_value
    FROM analytic.fact_orders
) t
GROUP BY order_date
ORDER BY order_date
