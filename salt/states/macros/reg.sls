{% macro dword(path, key, value) -%}
{{ slspath }}.{{ key }}:
  reg.present:
    - name: {{ path }}
    - vname: {{ key }}
    - vtype: REG_DWORD
    - vdata: {{ value }}
{%- endmacro %}
