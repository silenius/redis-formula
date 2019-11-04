include:
  - redis.config
  - redis.install

{% set redis = salt.pillar.get('redis') %}

service_redis:
  service.running:
    - name: {{ redis.service }}
    - enable: True
    - watch:
      - file: redis_config_file
      - file: redis_override_config
    - require:
      - pkg: redis_pkg
