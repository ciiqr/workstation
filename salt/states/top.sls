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

base:
  {% call optional_high_states('default') %}
  '*':
  {%- endcall %}
  {% for role in salt['grains.get']('roles', []) -%}
  {% call optional_high_states(role) %}
  'roles:{{ role }}':
    - match: grain
  {%- endcall %}
  {% endfor -%}
