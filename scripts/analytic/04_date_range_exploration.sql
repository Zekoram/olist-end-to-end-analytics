/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS order_range_months
FROM analytic.fact_orders;

-- Determine the minimum and maximum gap between purchase time and approved time=
SELECT
    MIN(DATEDIFF(HOUR, order_purchase_timestamp, order_approved_at)) AS min_hour_to_approve,
    MAX(DATEDIFF(HOUR, order_purchase_timestamp, order_approved_at)) AS max_hour_to_approve
FROM analytic.fact_orders
WHERE order_approved_at IS NOT NULL;

-- Determine the fastest and slowest delivery 
SELECT
    MIN(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS fastest_delivery,
    MAX(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS slowest_delivery
FROM analytic.fact_orders
WHERE order_delivered_customer_date IS NOT NULL;

-- Determine the minimum and maximum gap between review creation and answer timestamp
SELECT
    MIN(DATEDIFF(HOUR, review_creation_date, review_answer_timestamp)) AS fastest_response,
    MAX(DATEDIFF(HOUR, review_creation_date, review_answer_timestamp)) AS slowest_response
FROM analytic.fact_reviews
WHERE review_answer_timestamp IS NOT NULL;





