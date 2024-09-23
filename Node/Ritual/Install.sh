#!/bin/bash
curl -s curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh?token=GHSAT0AAAAAACX3FUE5WGPDWYVZTG3L6KQWZXRGY3A | bash

# Запрашиваемые парамеры
request_param() {
    read -p "$1: " param
    echo $param
}

# Запрашиваем параметры у пользователя
echo "Введите необходимые переменные для ноды:"
PRIVATE_KEY=$(request_param "Введите ваш private key (должен начинаться с 0x)")
RPC_URL=$(request_param "Введите BASE RPC URL (в формате HTTPS)")

if [[ "$PRIVATE_KEY" == 0x* ]]; then
    echo "Private key введен верно"
else
    echo "Private key введен не верно, должен начинаться с 0х"
    exit 1
fi
REGISTRY_ADDRESS=0x3B1554f346DFe5c482Bb4BA31b880c1C18412170

echo "Устанавливаем необходимое ПО"
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install?token=GHSAT0AAAAAACX3FUE4IA7INVHRNGKA25CSZXRDWEQ) &>/dev/null
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/docker%20install?token=GHSAT0AAAAAACX3FUE4NUNBUMSHJ3EEQNFKZXRDX4A) &>/dev/null

echo "Необходимое ПО установлено, продолжаем установку ноды"

# Клонирование репозитория (шаг 5 оф. гайда)
cd $HOME
git clone https://github.com/ritual-net/infernet-container-starter && cd infernet-container-starter

# Конфигурируем ноду (Пункт 7)

#deploy/config.json
DEPLOY=$HOME/infernet-container-starter/deploy/config.json
sed -i 's|"rpc_url": "[^"]*"|"rpc_url": "'"$RPC_URL"'"|' "$DEPLOY"
sed -i 's|"private_key": "[^"]*"|"private_key": "'"$PRIVATE_KEY"'"|' "$DEPLOY"
sed -i 's|"registry_address": "[^"]*"|"registry_address": "'"$REGISTRY_ADDRESS"'"|' "$DEPLOY"
sed -i 's|"sleep": 3|"sleep": 5|' "$DEPLOY"
sed -i 's|"batch_size": 100|"batch_size": 1800, "starting_sub_id": 100000|' "$DEPLOY"

#container/config.json
CONTAINER=$HOME/infernet-container-starter/projects/hello-world/container/config.json

sed -i 's|"rpc_url": "[^"]*"|"rpc_url": "'"$RPC_URL"'"|' "$CONTAINER"
sed -i 's|"private_key": "[^"]*"|"private_key": "'"$PRIVATE_KEY"'"|' "$CONTAINER"
sed -i 's|"registry_address": "[^"]*"|"registry_address": "'"$REGISTRY_ADDRESS"'"|' "$CONTAINER"
sed -i 's|"sleep": 3|"sleep": 5|' "$CONTAINER"
sed -i 's|"batch_size": 100|"batch_size": 1800, "starting_sub_id": 100000|' "$CONTAINER"

#contracts/Makefile
MAKEFILE=$HOME/infernet-container-starter/projects/hello-world/contracts/Makefile
sed -i 's|sender := .*|sender := '"$PRIVATE_KEY"'|' "$MAKEFILE"
sed -i 's|RPC_URL := .*|RPC_URL := '"$RPC_URL"'|' "$MAKEFILE"

#script/Deploy.s.sol
DEPLOYSOL=$HOME/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol
sed -i 's|address registry = .*|address registry = 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170 '"|' "$DEPLOYSOL"
