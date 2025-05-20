{{ config(materialized='table') }}

WITH orders_filtered AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
    WHERE status != 'cancelled'
),

orders_with_items AS (
    SELECT o.*
    FROM orders_filtered o
    WHERE EXISTS (
        SELECT 1
        FROM {{ ref('stg_order_items') }} oi
        WHERE oi.ORDER_ID = o.id
    )
),

joined_data AS (
    SELECT
        c.id AS customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        o.id AS order_id,
        o.date AS order_date,
        CAST(oi.QUANTITY AS NUMERIC) AS quantity,
        CAST(p.PRICE AS NUMERIC) AS price,
        CAST(oi.QUANTITY AS NUMERIC) * CAST(p.PRICE AS NUMERIC) AS amount_spent
    FROM orders_with_items o
    JOIN {{ ref('stg_customers') }} c ON o.customer_id = c.id
    JOIN {{ ref('stg_order_items') }} oi ON o.id = oi.ORDER_ID
    JOIN {{ ref('stg_products') }} p ON oi.PRODUCT_ID = p.ID
),

aggregated AS (
    SELECT
        customer_id,
        full_name,
        COUNT(DISTINCT order_id) AS number_of_orders,
        SUM(amount_spent) AS total_amount_spent_usd,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date
    FROM joined_data
    GROUP BY customer_id, full_name
)

SELECT * FROM aggregated
