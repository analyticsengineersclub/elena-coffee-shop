{% set product_cats = ['coffee beans', 'merch', 'brewing supplies'] %}

select
  date_trunc(order_date, month) as date_month,
    {% for product_cat in product_cats %}
  sum(case when product_category = '{{ product_cat }}' then price end) as {{product_cat|replace(" ","_")}}_amount
    {%- if not loop.last -%},{% endif %}
    {% endfor %}
from {{ ref('order_items') }}
group by 1