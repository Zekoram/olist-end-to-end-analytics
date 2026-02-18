/*
==========================================================================================
Sales Overview Report
==========================================================================================
Purpose:
    - Provides a high-level snapshot of overall sales performance and trends.

Highlights:
    1. Aggregates core sales metrics across time and product categories.
    2. Summarizes overall business performance using key KPIs.
    3. Supports trend analysis and category-wise contribution to total sales.

Metrics Included:
    - total_sales (sum of payment_value)
    - total_orders (distinct orders)
    - total_quantity (items sold)
    - sales by year and month
    - sales by product category

Key KPIs:
    - average order value (AOV)
    - monthly sales growth
    - category contribution to total sales
============================================================================================
*/

USE OlistDataWarehouse;
GO

-- =============================================================================
-- Create Report: analytic.report_sales_overview
-- =============================================================================
IF OBJECT_ID ('analytic.report_sales_overview', 'V') IS NOT NULL
    DROP VIEW analytic.report_sales_overview;
GO

CREATE VIEW analytic.report_sales_overview AS
WITH base_query AS (
    SELECT
        o.order_id,
        o.product_key,
        p.product_id,
        p.product_category,
        1 AS quantity,
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        o.payment_value AS sales_amount
    FROM analytic.fact_orders o
    LEFT JOIN analytic.dim_products p ON o.product_key = p.product_key
    WHERE o.order_purchase_timestamp IS NOT NULL
),
sales_aggregation AS (
    SELECT
        product_key,
        product_id,
        product_category,
        order_year,
        order_month,
        COUNT(DISTINCT order_id) AS orders_with_product,
        SUM(quantity) AS total_quantity,
        CAST(SUM(sales_amount) AS DECIMAL(12, 2)) AS total_sales
    FROM base_query
    GROUP BY product_key, product_id, product_category, order_year, order_month
),
category_totals AS (
    SELECT
        SUM(total_sales) AS overall_sales,
        product_category,
        SUM(SUM(total_sales)) OVER(PARTITION BY product_category) AS sales_by_category
    FROM sales_aggregation
    GROUP BY product_category
),
final_report AS (
    SELECT
        sa.product_key,
        sa.product_id,
        sa.product_category,
        sa.order_year,
        sa.order_month,
        sa.orders_with_product,
        sa.total_quantity,
        sa.total_sales,
        SUM(sa.total_sales) OVER(PARTITION BY sa.order_year) AS sales_by_year,
        SUM(sa.total_sales) OVER(PARTITION BY sa.order_year, sa.order_month) AS monthly_sales,
        CAST(sa.total_sales * 1.0 / NULLIF(sa.orders_with_product, 0) AS DECIMAL(10,2)) AS avg_revenue_per_order,
        ct.sales_by_category,
        ct.overall_sales
    FROM sales_aggregation sa
    LEFT JOIN category_totals ct ON sa.product_category = ct.product_category
)
SELECT
    *,
    CAST(100.0 * sales_by_category / NULLIF(overall_sales, 0) AS DECIMAL(10,2)) AS pct_category_contribution,
    LAG(monthly_sales) OVER(PARTITION BY product_key ORDER BY order_year, order_month) AS prev_month_sales,
    CAST(100.0 * (monthly_sales - LAG(monthly_sales) OVER(PARTITION BY product_key ORDER BY order_year, order_month)) 
        / NULLIF(LAG(monthly_sales) OVER(PARTITION BY product_key ORDER BY order_year, order_month), 0) AS DECIMAL(10,2)) AS monthly_sales_growth_pct
FROM final_report;

SELECT * FROM analytic.report_sales_overview;