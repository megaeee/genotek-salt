# vim: syntax=yaml  
{{ sls }}. Add token for yc-user:
  file.managed:
    - name: /home/yc-user/.token
    - contents: {{ grains["yc"]["token"] }}

{{ sls }}. python-pip:
  pkg.installed:
    - name: python-pip

{{ sls }}. Update awscli:
  pip.installed:
    - name: awscli
    - upgrade: True
    - require:
      - pkg: python-pip

{% set yc_config='/home/yc-user/yandex-cloud/bin/yc config' %}
{{ sls }}. Profile create:
  cmd.run:
    - name: {{ yc_config }} profile create test-profile

{{ sls }}. Set cloud ID:
  cmd.run:
    - name: {{ yc_config }} set cloud-id {{ grains["yc"]["cloud-id"] }}

{{ sls }}. Set folder ID:
  cmd.run:
    - name: {{ yc_config }} set folder-id {{ grains["yc"]["folder-id"] }}

{{ sls }}. Set instance SA flag:
  cmd.run:
    - name: {{ yc_config }} set instance-service-account true
