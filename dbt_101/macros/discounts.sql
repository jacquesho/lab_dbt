{% macro get_discount_eligibility(order_count, total_amount_spent) %}
  ({{ order_count }} >= 3 OR {{ total_amount_spent }} >= 300)
{% endmacro %}

{% macro calculate_discount(order_count, total_amount_spent) %}
  CASE
    WHEN {{ order_count }} <= 3 THEN ROUND({{ total_amount_spent }} * 0.03, 2)
    WHEN {{ order_count }} > 3 THEN ROUND({{ total_amount_spent }} * 0.05, 2)
  END
{% endmacro %}
