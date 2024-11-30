#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
#удаляем все старые screen сессии
pkill screen
#удаляем папку с нодой
rm -r cysic-verifier
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
WALLET_ADDRESS=$(request_param "Введите ваш адрес кошелька")
green "Устанавливаем необходимое ПО"
green "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
green "Обновление успешно завершено"
sleep 3
green "Настраиваем файл подкачки...."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Swap_6GB)
sleep 2
green "Устанавливаем ноду...."
# клонируем ноду
curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh && bash ~/setup_linux.sh $WALLET_ADDRESS
#создаем сервисный файл
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
