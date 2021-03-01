# vim: syntax=yaml
/vm_init_start:
  file.touch

/shutdown_mark:
  file.absent

Delete swap file:
  file.absent:
    - name: /8G.swap
    - unless:
      - file: /vm_init_start

Enable swap file:
  cmd.run:
    - name: |
        set -e
        fallocate -l 8G /8G.swap
        chmod 0600 /8G.swap
        mkswap /8G.swap
        swapon /8G.swap
        echo "/8G.swap none swap sw 0 0" >> /etc/fstab
    - unless:
      - grep /8G.swap /etc/fstab
