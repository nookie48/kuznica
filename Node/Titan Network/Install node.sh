#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"

# Запрашиваемые парамеры
request_param() {
    read -p "$1: " param
    echo $param
}
# Зеленый цвет сервисных сообщений echo
green() {
    echo -e "\e[32m$1\e[0m"
}
# Запрашиваем параметры у пользователя
green "Введите необходимые переменные для ноды"
YOUR_KEY=$(request_param "Введите ваш KEY")
green "Устанавливаем необходимое ПО"
green "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
green "Обновление успешно завершено"
sleep 3
green "Устанавливаем ноду...."
sudo apt install snapd
sleep 1
sudo snap install multipass
sleep 1
wget https://pcdn.titannet.io/test4/bin/agent-linux.zip
sleep 1
mkdir -p /opt/titanagent
sleep 1
unzip agent-linux.zip -d /opt/titanagent
green "Создаем сервис...."
cd /etc/systemd/system/
wget https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Node/Cysic/cysic-verifier.service
sleep 3
cd $HOME
sudo systemctl daemon-reload
sleep 5
sudo systemctl enable cysic-verifier
sleep 5
# запускаем сервис
green "Запускаем сервис"
sudo systemctl start cysic-verifier
echo -e "\e[1;41m!!!ВНИМАНИЕ!!! НЕ ЗАБУДЬТЕ СДЕЛАТЬ БЕКАП ПАПКИ !!!/root/.cysic/keys/!!!\e[0m"
sleep 3
green "Нода успешно установлена, можете проверить логи командой 'journalctl -u cysic-verifier.service -f' Red желает вам удачи!"
