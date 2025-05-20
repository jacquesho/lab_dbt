SELECT
    CAST(id AS INT) AS id,
    CAST(first_name AS STRING) AS first_name,
    CAST(last_name AS STRING) AS last_name,
    CAST(email AS STRING) AS email,
    CAST(gender AS STRING) AS gender,
    CAST(date_of_birth AS DATE) AS date_of_birth
FROM {{ source('grocery_store', 'customers') }}