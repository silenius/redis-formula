{% set redis = salt.pillar.get('redis') %}

redis_pkg:
  pkg.installed:
    - name: {{ redis.pkg }}
