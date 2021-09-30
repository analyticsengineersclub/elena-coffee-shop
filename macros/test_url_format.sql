{% test url_format(model, column_name) %}

{{config(severity = 'error', error_if = '> 5')}}
    select
        {{ column_name }}

    from {{ model }}
		where not regexp_contains({{column_name}}, r"^[a-z0-9-_/]+$")
{% endtest %}