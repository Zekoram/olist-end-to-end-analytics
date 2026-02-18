/*
===============================================================================
Customer Insights Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as customer_id and transaction details.
	2. Segments customers into categories (VIP, Regular).
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - total_sales per customer
    4. Calculates valuable KPIs:
		- average order value
===============================================================================
*/

USE OlistDataWarehouse;
GO

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================

IF OBJECT_ID('analytic.report_customer_insights', 'V') IS NOT NULL
	DROP VIEW analytic.report_customer_insights;
GO

CREATE VIEW analytic.report_customer_insights AS 
WITH base_query AS (
    SELECT
        o.order_id,
        o.product_key,
        o.order_purchase_timestamp AS order_date,
        o.payment_value AS sales_amount,
        1 AS quantity,                           -- As each row represent one item
        o.customer_key,
        c.customer_id
    FROM analytic.fact_orders o
    LEFT JOIN analytic.dim_customers c
        ON o.customer_key = c.customer_key
    WHERE o.order_purchase_timestamp IS NOT NULL
),
customer_aggregation AS (
    SELECT
        customer_key,
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date
    FROM base_query 
    GROUP BY customer_key, customer_id
)
SELECT
    customer_key,
    customer_id,
    CASE
        WHEN total_sales >= 2000 THEN 'VIP'
        WHEN total_sales >= 1000 THEN 'Regular'
        ELSE 'Low'
    END AS customer_segment,
    last_order_date,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    -- Average Order Value = Sales / Orders
    CAST(total_sales * 1.0 / NULLIF(total_orders, 0) AS DECIMAL(10,2)) AS avg_order_value,
    -- Average items per order
    CAST(total_quantity * 1.0 / NULLIF(total_orders, 0) AS DECIMAL(5,2)) AS avg_items_per_order
FROM customer_aggregation;


	    
