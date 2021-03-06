#!/bin/bash

#1. Скачиваем cjdns из GitHub.
#Склонируйте репозиторий из GitHub:
cd ~/2ndLaba
git clone https://github.com/cjdelisle/cjdns.git cjdns
cd cjdns

#2. Компилируем.
./do
#Дождитесь сообщения Build completed successfully, type ./cjdroute to begin setup., и как только оно появится — действуйте дальше:

#Установка
#Запустите cjdroute без параметров для отображения информации и доступных опций:
./cjdroute

#0: Убедитесь, что у вас всё установлено корректно.
ans=$(echo LANG=C cat /dev/net/tun )

#Если ответ: cat: /dev/net/tun: File descriptor in bad state,то всё отлично!

#Если ответ: cat: /dev/net/tun: No such file or directory,то просто создайте его:
if [[ "$ans" == "cat: /dev/net/tun: No such file or directory" ]]
then sudo mkdir /dev/net ; sudo mknod /dev/net/tun 
else echo "Установлено бомбезно"
fi

ans=$(echo cat /dev/net/tun)
if [[ "$ans" == "cat: /dev/net/tun: Permission denied" ]]
then echo "Попросите своего провайдера услуг включить TUN/TAP устройство"
fi

#Если ответ: cat: /dev/net/tun: Permission denied, вы скорее всего используете виртуальный сервер (VPS) на основе технологии виртуализации OpenVZ. Попросите своего провайдера услуг включить TUN/TAP устройство, это стандартный протокол, ваш провайдер должен быть в курсе.

#1: Генерируем новый файл с настройками.
./cjdroute --genconf >> cjdroute.conf

#Запускаем cjdns
echo "Работаем"
sudo ./cjdroute < cjdroute.conf

#wait 20 seconds
sleep 20

#Остановка cjdns
echo "Поработали бомбезно"
sudo killall cjdroute
