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
echo "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
echo "Устанавливаю Docker, пожалуйста, подождите..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/docker%20install) &>/dev/null
echo "Необходимое ПО установлено, продолжаем установку ноды"

# Клонирование репозитория (шаг 5 оф. гайда)
cd $HOME
git clone https://github.com/ritual-net/infernet-container-starter && cd infernet-container-starter
cp $HOME/infernet-container-starter/projects/hello-world/container/config.json $HOME/infernet-container-starter/deploy/config.json

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
sed -i 's|address registry = .*|address registry = 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170;|' "$HOME/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol"

#Инициализируем новую конфигурацию
sed -i 's|ritualnetwork/infernet-node:1.0.0|ritualnetwork/infernet-node:1.3.0|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|0.0.0.0:4000:4000|0.0.0.0:4321:4000|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|8545:3000|8845:3000|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|container_name: infernet-anvil|container_name: infernet-anvil\n    restart: on-failure|' $HOME/infernet-container-starter/deploy/docker-compose.yaml

docker compose -f $HOME/infernet-container-starter/deploy/docker-compose.yaml up -d

# Устанавливаем Foundry
cd $HOME
mkdir -p foundry
cd foundry
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
echo 'export PATH="$PATH:/root/.foundry/bin"' >> .profile
source .profile

foundryup

#installing required libraries and SDKs
cd $HOME/infernet-container-starter/projects/hello-world/contracts/lib/
rm -r forge-std
rm -r infernet-sdk
forge install --no-commit foundry-rs/forge-std
forge install --no-commit ritual-net/infernet-sdk

# Deploy Consumer Contract
cd $HOME/infernet-container-starter
project=hello-world make deploy-contracts >> logs.txt
CONTRACT_ADDRESS=$(grep "Deployed SaysHello" logs.txt | awk '{print $NF}')
rm -rf logs.txt

if [ -z "$CONTRACT_ADDRESS" ]; then
  echo -e "${err}!!!Ошибка!!! Отсутствует contractAddress из $CONTRACT_DATA_FILE${end}"
  exit 1
fi

echo -e "${fmt}Адрес созданного контракта: $CONTRACT_ADDRESS${end}"
sed -i 's|0x13D69Cf7d6CE4218F646B759Dcf334D82c023d8e|'$CONTRACT_ADDRESS'|' "$HOME/infernet-container-starter/projects/hello-world/contracts/script/CallContract.s.sol"

# Call Consumer Contract
cd $HOME/infernet-container-starter
project=hello-world make call-contract
