#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
sudo apt update && sudo apt upgrade -y
green() {
    echo -e "\e[32m$1\e[0m"
}
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Rust.sh)
apt install screen
green "Настраиваем файл подкачки...."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Swap_12GB)
sleep 2
wget https://github.com/protocolbuffers/protobuf/releases/download/v29.3/protoc-29.3-linux-x86_64.zip
unzip protoc-29.3-linux-x86_64.zip -d protoc-29.3
sudo mv protoc-29.3/bin/protoc /usr/local/bin/
sudo mv protoc-29.3/include/* /usr/local/include/
export PATH="/usr/local/bin:$PATH"
source ~/.bashrc
sudo mv /usr/bin/protoc /usr/bin/protoc_old
green "Подготовка для установки ноды завершена. Далее выполните 2 команды по очереди: screen -S nexus ; curl https://cli.nexus.xyz/ | sh  Red желает вам удачи!"

