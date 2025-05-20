{{ config(materialized='view') }}

SELECT
    customer_id,
    number_of_orders AS number_of_orders,
    total_amount_spent_usd AS total_amount_spent,
    {{ get_discount_eligibility('number_of_orders', 'total_amount_spent_usd') }} AS is_eligible_for_discount,
    {{ calculate_discount('number_of_orders', 'total_amount_spent_usd') }} AS discount_usd
FROM {{ ref('int_customers_orders_joined') }}
