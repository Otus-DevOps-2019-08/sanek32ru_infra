# sanek32ru_infra
Alexander Peven OTUS-DevOps-2019-08 Infra repository

# Домашние задания

## HomeWork 2: GitChatOps

* Создан шаблон PR
* Создана интеграция с TravisCI
```bash
 travis encrypt "devops-team-otus:<ваш_токен>#<имя_вашего_канала>" --add notifications.slack.rooms --com
```
* Создана интеграция с чатом для репозитория
* Создана интеграция с чатом для TravisCI
* Отработаны навыки работы с GIT

## HomeWork 3: Знакомство с облачной инфраструктурой. Google Cloud Platform

* Создана УЗ в GCP
* Созданы 2 ВМ: bastion с внешним IP и someinternalhost тосько с внутренним ip
* Настроено сквозное подключение по SSH к хосту someinternalhost посредством выполнения команды
`ssh someinternalhost` для чего:
  * при создании ВМ сгенерирован ssh-ключ `Asus`
  * ключ Asus добавлен в ssh-агент
  * в файл `~/.ssh/config` добавлены строки
    ```
    Host bastion
    	IdentityFile ~/.ssh/
    	User Asus
    	HostName 35.210.132.96
    Host someinternalhost
    	IdentityFile ~/.ssh/
    	User Asus
    	HostName 10.132.0.3
    	ProxyJump bastion
    ```
  В результате, при выполнении команды `ssh someinternalhost`, происходит следующее:
  * Устанавливается соединение с `bastionhost` посредством подключения к `Asus@35.210.132.96` с использованием ключа `~/.ssh/Asus`
  * С хоста `bastionhost` устанавливается перенаправление TCP на `someinternalhost` посредством подключения к `Asus@10.132.0.3` с использованием ключа `~/.ssh/Asus`, это происходит даже если не добавлять ключ `~/.ssh/Asus` в ssh-agent
  * Аналогом директивы ProxyJump может быть опция `-J <jump host>` команды `ssh`, например
    ```shell
    ssh-add -L ~/.ssh/Asus
    ssh -i ~/.ssh/Asus -J Asus@35.210.132.96 Asus@10.132.0.3
    ```
    В случае такого способа, ssh-ключь должен быть добавлен в ssh-агент, иначе возникает ошибка
    ```
    Asus@35.210.132.96: Permission denied (publickey).
    ssh_exchange_identification: Connection closed by remote host
    ```
* Установлен и настроен vpn-сервер [pritunl](https://pritunl.com)
  ```
  bastion_IP = 35.210.132.96
  someinternalhost_IP = 10.132.0.3
  ```
  * Создана организация
  * Создан пользователь
  * Создан сервер
  * Добавлен маршрут ко внутренней сети
  * Сервер прикреплён к организации