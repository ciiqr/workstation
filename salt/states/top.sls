{% from "macros/optional.sls" import optional_high_states with context %}

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
