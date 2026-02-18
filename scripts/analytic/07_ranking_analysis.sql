/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    p.product_id,
    SUM(o.payment_value) AS total_revenue
FROM analytic.fact_orders o
LEFT JOIN analytic.dim_products p
    ON o.product_key = p.product_key
GROUP BY p.product_id
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT 
        p.product_id,
        SUM(o.payment_value) AS total_revenue,
        RANK() OVER(ORDER BY SUM(o.payment_value) DESC) AS rank_products
    FROM analytic.fact_orders o
    LEFT JOIN analytic.dim_products p
        ON o.product_key = p.product_key
    GROUP BY p.product_id
) AS ranked_products
WHERE rank_products <=5; 

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    p.product_id,
    SUM(o.payment_value) AS total_revenue
FROM analytic.fact_orders o
LEFT JOIN analytic.dim_products p
    ON o.product_key = p.product_key
GROUP BY p.product_id
ORDER BY total_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_id,
    SUM(o.payment_value) AS total_revenue
FROM analytic.fact_orders o
LEFT JOIN analytic.dim_customers c
    ON o.customer_key = c.customer_key
GROUP BY c.customer_id
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_id,
    COUNT(o.order_id) AS total_orders
FROM analytic.fact_orders o
LEFT JOIN analytic.dim_customers c
    ON o.customer_key = c.customer_key
GROUP BY c.customer_id
ORDER BY total_orders;

-- Find the top 10 sellers who have sold most_items
SELECT TOP 10
    s.seller_id,
    COUNT(*) AS total_quantity
FROM (SELECT DISTINCT o.order_id, o.order_item_id, o.seller_key FROM analytic.fact_orders o WHERE o.order_item_id IS NOT NULL) AS t
LEFT JOIN analytic.dim_sellers s
    ON t.seller_key = s.seller_key
GROUP BY s.seller_id
ORDER BY total_quantity DESC;

-- The 3 sellers with the fewest items sold
SELECT TOP 3
    s.seller_id,
    COUNT(*) AS total_quantity
FROM (SELECT DISTINCT o.order_id, o.order_item_id, o.seller_key FROM analytic.fact_orders o WHERE o.order_item_id IS NOT NULL) AS t
LEFT JOIN analytic.dim_sellers s
    ON t.seller_key = s.seller_key
GROUP BY s.seller_id
ORDER BY total_quantity;