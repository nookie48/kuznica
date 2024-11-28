#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
# Запрашиваемые парамеры
request_param() {
    read -p "$1: " param
    echo $param
}

# Запрашиваем параметры у пользователя
echo "Введите необходимые переменные для ноды:"
WALLET_ADDRESS=$(request_param "Введите ваш адрес кошелька")
echo "Устанавливаем необходимое ПО"
echo "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
echo "Обновление успешно завершено."
# клонируем ноду
curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh && bash ~/setup_linux.sh $WALLET_ADDRESS
#создаем сервисный файл
cd $HOME/etc/systemd/system/
wget https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Node/Cysic/cysic-verifier.service
cd $HOME
sudo systemctl daemon-reload
sudo systemctl enable cysic-verifier
# запускаем сервис
sudo systemctl start cysic-verifier
#открываем логи
journalctl -u cysic-verifier.service -f
