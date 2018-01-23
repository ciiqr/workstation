{% macro optional_high_states() -%}
  {%- if salt['rootscheck.any_state_exists'](*varargs) -%}
    {{ caller() }}
    {%- for name in varargs %}
      {%- if salt['rootscheck.state_exists'](name) %}
    - {{ name }}
      {%- endif -%}   
    {% endfor %}
  {%- endif -%}   
{%- endmacro %}
