/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

USE OlistDataWarehouse;
GO

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        p.product_id,
        SUM(o.payment_value) AS current_sales
    FROM analytic.fact_orders o
    LEFT JOIN analytic.dim_products p
        ON o.product_key = p.product_key
    GROUP BY 
        YEAR(o.order_purchase_timestamp), 
        product_id
)
SELECT
    order_year,
    product_id,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY product_id) AS average_sales,
    current_sales - AVG(current_sales) OVER(PARTITION BY product_id) AS diff_sales,
    CASE
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_id) > 0 THEN 'Above Average'
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_id) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change,
    LAG(current_sales) OVER(PARTITION BY product_id ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY product_id ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_id ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_id ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY order_year, product_id

SELECT
    p.product_id,
    COUNT(DISTINCT YEAR(o.order_purchase_timestamp)) AS years_sold
FROM analytic.fact_orders o
LEFT JOIN analytic.dim_products p
    ON o.product_key = p.product_key
GROUP BY product_id
ORDER BY years_sold;
