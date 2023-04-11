{%- macro flatten_json(model_name, json_column) -%}


{%- set json_column_query -%}
   SELECT DISTINCT
        key AS column_name
   ,   typeof( value ) AS data_type
   FROM {{ model_name }}
      , LATERAL flatten( INPUT => parse_json( {{ json_column }} ) )
{%- endset -%}

{%- set results = run_query( json_column_query ) -%}
   {%- if execute -%}
   {%- set result_list = results.columns[0].values() -%}
   {%- else -%}
   {%- set result_list = [] -%}
   {%- endif -%}


{% for column_name in result_list %}
 , parse_json( {{ json_column }}):{{ column_name }}::float AS {{ column_name }}
{%- endfor -%}

{%- endmacro -%}