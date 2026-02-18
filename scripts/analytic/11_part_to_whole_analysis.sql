/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH category_sales AS(
    SELECT
        p.product_category,
        SUM(o.payment_value) AS total_sales
    FROM analytic.fact_orders o
    LEFT JOIN analytic.dim_products p
        ON o.product_key = p.product_key
    GROUP BY p.product_category
)
SELECT
    product_category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;