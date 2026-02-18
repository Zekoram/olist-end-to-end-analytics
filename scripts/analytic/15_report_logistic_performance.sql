/*
===============================================================================
Logistic Performance Report
===============================================================================
Purpose:
    - Analyze delivery efficiency and operational performance

Highlights:
    1. Focuses on order fulfillment and delivery timelines.
    2. Evaluates on-time vs late delivery performance.
    3. Analyzes logistics performance by seller and geography.
    4. Aggregates product-level metrics:
        - total_orders
        - total_items_shipped
        - average delivery time 
        - late delivery count
        - on-time delivery count
    4. Calculates valuable KPIs:
        - delivery_days = delivered_customer_date ? order_purchase_date
        - late_delivery_flag (Yes / No)
        - average delivery days
        - % late deliveries
===============================================================================
*/

USE OlistDataWarehouse;
GO

-- =============================================================================
-- Create Report: analytic.report_logistic_performance
-- =============================================================================

IF OBJECT_ID('analytic.report_logistic_performance', 'V') IS NOT NULL
    DROP VIEW analytic.report_logistic_performance;
GO

CREATE VIEW analytic.report_logistic_performance AS
WITH base_query AS (
    SELECT
        o.order_id,
        1 AS quantity,
        o.order_purchase_timestamp AS order_date,
        o.order_delivered_customer_date AS delivery_date, 
        o.order_estimated_delivery_date AS estimated_delivery_date,
        s.seller_state,
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month
    FROM analytic.fact_orders o
    LEFT JOIN analytic.dim_sellers s
        ON o.seller_key = s.seller_key
    WHERE o.order_purchase_timestamp IS NOT NULL 
      AND o.order_delivered_customer_date IS NOT NULL
), 
logistic_aggregation AS (
    SELECT
        order_year,
        order_month,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(1) AS total_items_shipped,  -- Since quantity = 1
        AVG(CAST(DATEDIFF(DAY, order_date, delivery_date) AS FLOAT)) AS avg_delivery_days,
        SUM(CASE WHEN delivery_date > estimated_delivery_date THEN 1 ELSE 0 END) AS late_delivery_count,
        SUM(CASE WHEN delivery_date <= estimated_delivery_date THEN 1 ELSE 0 END) AS on_time_delivery_count,
        COUNT(*) AS total_deliveries
    FROM base_query
    GROUP BY order_year, order_month
)
SELECT
    order_year,
    order_month,
    total_orders,
    total_items_shipped,
    CAST(avg_delivery_days AS DECIMAL(10,2)) AS avg_delivery_days,
    late_delivery_count,
    on_time_delivery_count,
    CAST((late_delivery_count * 100.0 / NULLIF(total_deliveries, 0)) AS DECIMAL(10,2)) AS pct_late_deliveries
FROM logistic_aggregation;

