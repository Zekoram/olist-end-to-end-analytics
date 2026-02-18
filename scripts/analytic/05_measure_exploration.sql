/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

USE OlistDataWarehouse;
GO

-- Find the Total Sales
SELECT SUM(payment_value)AS total_sales FROM analytic.fact_orders;

-- Find how many items are sold
SELECT COUNT(*) AS total_quantity FROM (SELECT DISTINCT order_id, order_item_id FROM analytic.fact_orders WHERE order_item_id IS NOT NULL) AS t

-- Find the Average Selling Price
SELECT AVG(price) AS avg_selling_price FROM analytic.fact_orders;

-- Find the Total number of Orders
SELECT COUNT(DISTINCT order_id) AS total_orders FROM analytic.fact_orders;

-- Find the total number of products
SELECT COUNT(DISTINCT product_id) AS total_products FROM analytic.dim_products;

-- Find the total number of customers
SELECT COUNT(customer_id) AS total_customers FROM analytic.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS customers_with_orders FROM analytic.fact_orders;

-- Find the total number of sellers
SELECT COUNT(seller_id) AS total_sellers FROM analytic.dim_sellers;

