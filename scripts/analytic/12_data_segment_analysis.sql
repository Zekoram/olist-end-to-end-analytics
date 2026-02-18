/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

USE OlistDataWarehouse;
GO

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH product_segments AS (
    SELECT
        p.product_id,
        o.price AS cost,
        CASE 
            WHEN o.price < 100 THEN 'Below 100'
            WHEN o.price BETWEEN 100 AND 500 THEN '100-500'
            WHEN o.price BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM analytic.fact_orders o
    LEFT JOIN analytic.dim_products p
        ON o.product_key = p.product_key
)
SELECT
    cost_range,
    COUNT(product_id) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 3 months of history and spending more than R$5,000.
	- Regular: Customers with at least 3 months of history but spending R$5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_spending AS (
    SELECT
        customer_key,
        SUM(payment_value) AS total_sales,
        MIN(order_purchase_timestamp) AS first_order,
        MAX(order_purchase_timestamp) AS last_order,
        DATEDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS lifespan
    FROM analytic.fact_orders
    GROUP BY customer_key
)
SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN total_sales > 5000 AND lifespan >= 3 THEN 'VIP'
            WHEN total_sales <= 5000 AND lifespan >= 3 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;