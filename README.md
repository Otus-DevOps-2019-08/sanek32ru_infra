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

## HomeWork 4: Основные сервисы GCP
testapp_IP = 35.235.38.237
testapp_port = 9292

* Создаём новую ветку в репозитории
$ git checkout -b cloud-testapp

* Переносим файлы прошлого ДЗ в отдельную папку VPN
$ git mv setupvpn.sh VPN/setupvpn.sh
Аналогично для второго файла

* Устанавливаем google SDK по инструкции https://cloud.google.com/sdk/docs/

* Создаём новый инстанс
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
```
* Подключаемся к серверу и устанавливаем Ruby
```
$ ssh vlad@reddit-app
$ sudo apt update
$ sudo apt install -y ruby-full ruby-bundler build-essential
```

* Устанавливаем MongoDB, запускаем и добавляем в автозапуск.
```
$ wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -
$ echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
$ sudo apt update
$ sudo apt install -y mongodb-org
$ sudo systemctl start mongod
$ sudo systemctl enable mongod
```

* Деплоим приложение.
```
$ git clone -b monolith https://github.com/express42/reddit.git
$ cd reddit && bundle install
$ puma -d
```

## Дополнительное задание №1
```
gcloud compute instances create reddit-app-test\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=/home/vlad/devops_courses/finrerty_infra/startup_script.sh
```

*Если хотим загрузить из url, то помещаем файл в bucket и используем строку 
```
--metadata startup-script-url=gs://bucket/startup_script.sh
```

## Дополнительное задание №2
Создание правила фаерволла:
```
gcloud compute firewall-rules create puma-rule --allow tcp:9292 --target-tags=puma-server
```

## HomeWork 5: Packer
Домашнее задание: Сборка образа при помощи Packer

* Создан образ VM  `reddit-base`(без параметров)
./packer
```
packer build ubuntu16.json
```
* Создан образ VM `reddit-base` (с параметрами)

./packer 
```
packer build -var-file=variables.json.example  ubuntu16.json
```

* Запускаем инстанс из созданного образа и на нем сразу
же имеем запущенное приложение

## HomeWork 6: terraform-1

- Описана инфраструктура в `main.tf`
- Описаны переменные в `variables.tf`
- Переменным задано значение через `terraform.tfvars`
- Заданны переменные для "google_compute_instance" "app" "Zone"
- Все файлы отформатированы командой `terraform fmt`
- Создан `terraform.tfvars.example`
