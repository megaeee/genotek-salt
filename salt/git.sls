# vim: syntax=yaml
{{ sls }}. Prepare repo target:
  file.directory:
    - name: /mnt/tmp
    - user: root
    - group: root
    - dir_mode: 770
    - file_mode: 660
    - follow_symlinks: True
    - recurse:
      - user
      - group
      - mode

{{ sls }}. Clone gitlab repo:
  git.latest:
    - name: https://gitlab.com/genotek/genotek.git
    - https_user: {{ grains['git']['user'] }}
    - https_pass: {{ grains['git']['password'] }}
    - target: /mnt/genotek
    - branch: vm-rerun
    - retry:
        attempts: 10
        until: True
        interval: 15

{{ sls }}. Send telegram notification:
  cmd.run:
    - name: "telegram_notification \"!!! Instance $HOSTNAME could not download code from the repository !!!\";"
    - onfail:
      - git: "{{ sls }}. Clone gitlab repo"

{{ sls }}. Halt system:
  system.halt:
    - onfail:
      - git: "{{ sls }}. Clone gitlab repo"

{{ sls }}. Move files:
  cmd.run:
    - require:
      - git: "{{ sls }}. Clone gitlab repo"
    - cwd: /mnt
    - name: "mv -fv genotek/* genotek/.git . "

{{ sls }}. Make scripts executable:
  file.directory:
    - name: /mnt/scripts
    - file_mode: 777
    - follow_symlinks: True
    - recurse:
      - mode

{{ sls }}. Cleanup:
  file.absent:
    - name: /mnt/genotek
