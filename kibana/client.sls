{%- from "kibana/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

/etc/salt/minion.d/_kibana.conf:
  file.managed:
  - source: salt://kibana/files/_kibana.conf
  - template: jinja
  - user: root
  - group: root

{%- for object_name, object in client.get('object', {}).iteritems() %}
kibana_object_{{ object_name }}:
  {%- if object.get('enabled', False) %}
  {% import_json object.template as content %}
  kibana_object.present:
  - kibana_content: {{ content|json }}
  {%- else %}
  kibana_object.absent:
  {%- endif %}
  - name: {{ object_name }}
  - kibana_type: {{ object.type }}
{%- endfor %}

{%- endif %}
