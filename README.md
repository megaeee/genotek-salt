# genotek-salt
## Подготовка
Пакеты на машине:
  - salt-common
  - salt-minion

Расположить директорию salt в /srv/ на виртуальной машине. Т.е. top.sls должен быть доступен по абсолютному пути /srv/salt/top/sls

## Пример cloud-init'a

    #cloud-config
    users:
        - name: user1
          sudo: "ALL=(ALL) NOPASSWD:ALL"
          shell: /bin/bash
          ssh-authorized-keys:
              - "key1"
    salt_minion:
        pkg_name: 'salt-minion'
        config_dir: '/etc/salt'
        conf:
            file_client: local
        grains:
            yc:
                cloud-id:
                    CLOUDID
                folder-id:
                    FOLDERID
                token:
                    TOKEN
            experiment:
                id:
                    EXP_ID
            git:
                password:
                    PASS
                user:
                    USER
    runcmd:
        - "sudo salt-call service.stop salt-minion"
        - "sudo salt-call service.disable salt-minion"
        - "sudo salt-call state.apply"
    output:
        init:
            output: "> /var/log/cloud-init.out"
            error: "> /var/log/cloud-init.err"
        config:
            output: "> /var/log/cloud-config.out"
            error: "> /var/log/cloud-config.err"
        final:
            output: "> /var/log/cloud-final.out"
            error: "> /var/log/cloud-final.err"

## Термины
grains - переменные, уникальные для каждого хоста. Пароли там, как правило, не хранят, но для masterless-модели это нормально

pillars - переменные, общие для инсталляции. Ключи, пароли, сертификаты - всё туда

states - исполняемые последовательно модули. Описания можно посмотреть, напрмер, [тут](https://docs.saltproject.io/en/latest/ref/states/all/salt.states.cmd.html). О модификаторах исполнения для state'ов можно глянуть [тут](https://docs.saltproject.io/en/latest/ref/states/requisites.html)