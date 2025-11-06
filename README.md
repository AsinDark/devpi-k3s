# Локальный Devpi сервер (PyPI-репозиторий)
## Окружение
**ОС:** Windows 11  
**Используемое ПО:**
- Vagrant 2.4.9
- VirtualBox 7.2.4
- WSL (Ubuntu 20.04 + Ansible 2.13.13)  
- VS Code с плагином *Remote - WSL*

**Образ devpi:** https://hub.docker.com/r/asindark/devpi

---
**Инструкция по установке:**

Все команды выполняем из директории проекта.

Поменять и запомнить пароль от devpi в `ansible/roles/devpi_pass/defaults/main.yml`

Поднимаем виртуальную машину:
`vagrant up`

Подключаемся в wls и оттуда копируем серитификат для ansible и запускаем плейбук:
`cp ./.vagrant/machines/k3s-node/virtualbox/private_key ~/.ssh/id_rsa_k3s`
`chmod 600 ~/.ssh/id_rsa_k3s`
`ansible-playbook -i ansible/inventory.ini ansible/playbook.yml`

На ноде добавить строчку `10.0.2.15 devpi.local` в `/etc/hosts` . Перед этим перепроверить IP адрес ingress controller'а - `kubectl get ingress -n devpi`

Добавить строку `192.168.56.11 devpi.local` в `C:\Windows\System32\drivers\etc\hosts` на хостовой машине.
При желании установить сертификат из корня проекта в доверенные корневые сертификаты windows

Devpi из windows доступен по адресу https://devpi.local/

**Как загружать собственные пакеты:**
- Установить клиент (например на ту же самую ноду) - `pip install devpi-client==7.2.0`
- Залогиниться и ввести пароль из секрета - `devpi login root`
- Переключиться на специальный индекс - `devpi use root/devpi-local`
- В директори с пакетом - `devpi upload dist/*.tar.gz dist/*.whl`
- Собственные пакеты можно увидеть в вебе: http://devpi.local/root/devpi-local
