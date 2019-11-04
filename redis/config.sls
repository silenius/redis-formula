include:
  - redis.install

{% set redis = salt.pillar.get('redis') %}

redis_config_file:
  file.copy:
    - name: {{ redis.config_file }}
    - source: {{ redis.default_config_file }}
    - user: root
    - group: wheel
    - mode: 644
    - require:
      - pkg: redis_pkg

{% if redis.config is defined %}

{% for key, value in redis.config.items() %}

{% if key in ('dir', ) %}
redis_config_{{ key }}:
  file.directory:
    - name: {{ value }}
    - owner: redis
    - group: redis
    - mode: 755
    - watch_in:
      - file: redis_override_config_file
{% endif %}

{% endfor %}

redis_override_config_file:
  file.append:
    - name: {{ redis.config_file }}
    - text:
      - include {{ redis.override_config_file }}
    - require:
      - file: redis_config_file

redis_override_config:
  file.managed:
    - name: {{ redis.override_config_file }}
    - user: root
    - group: wheel
    - mode: 644
    - contents:
      {% for key, value in redis.config.items() %}
      - {{ key }} {{ value }}
      {% endfor %}
      {% if 'bind' not in redis.config %}
      - bind {{ salt.grains.get('ipv4:0') }}
      {% endif %}
    - require:
      - file: redis_override_config_file

{% endif %}
