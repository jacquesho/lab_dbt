SELECT
    CAST(id AS INT) AS id,
    CAST(date AS DATE) AS date,
    CAST(customer_id AS INT) AS customer_id,
    CAST(status AS STRING) AS status
FROM {{ source('grocery_store', 'orders') }}