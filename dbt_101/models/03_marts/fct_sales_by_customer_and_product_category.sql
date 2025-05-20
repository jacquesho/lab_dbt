{{ config(materialized='table') }}

{% set categories = dbt_utils.get_column_values(
    table=ref('stg_products'),
    column='CATEGORY'
) %}


WITH orders_filtered AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
    WHERE status != 'cancelled'
),

valid_order_items AS (
    SELECT oi.*
    FROM {{ ref('stg_order_items') }} oi
    INNER JOIN orders_filtered o ON oi.ORDER_ID = o.id
),

joined_data AS (
    SELECT
        o.customer_id,
        p.CATEGORY,
        oi.QUANTITY,
        p.PRICE,
        (oi.QUANTITY * p.PRICE) AS amount_spent
    FROM valid_order_items oi
    JOIN {{ ref('stg_orders') }} o ON oi.ORDER_ID = o.id
    JOIN {{ ref('stg_products') }} p ON oi.PRODUCT_ID = p.ID
),

aggregated AS (
    SELECT
        customer_id,
        {% for cat in categories %}
        SUM(CASE WHEN CATEGORY = '{{ cat }}' THEN QUANTITY ELSE 0 END) AS {{ cat | upper | replace(' ', '_') }}_UNITS_SOLD,
        SUM(CASE WHEN CATEGORY = '{{ cat }}' THEN amount_spent ELSE 0 END) AS AMOUNT_SPENT_{{ cat | upper | replace(' ', '_') }}{% if not loop.last %},{% endif %}
        {% endfor %}
    FROM joined_data
    GROUP BY customer_id
)

SELECT * FROM aggregated
