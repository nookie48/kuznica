#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
sudo apt update && sudo apt upgrade -y
green() {
    echo -e "\e[32m$1\e[0m"
}
sleep 1
sudo apt install build-essential pkg-config libssl-dev git-all -y
sleep 1
sudo apt install -y protobuf-compiler
sleep 1
sudo apt install cargo
sleep 1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sleep 1
source $HOME/.cargo/env
sleep 1
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
sleep 1
source ~/.bashrc
rustup update
sudo apt remove -y protobuf-compiler
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v25.2/protoc-25.2-linux-x86_64.zip
unzip protoc-25.2-linux-x86_64.zip -d $HOME/.local
export PATH="$HOME/.local/bin:$PATH"
apt install screen
green "Подготовка для установки ноды завершена. Далее выполните 2 команды по очереди: screen -S nexus ; curl https://cli.nexus.xyz/ | sh  Red желает вам удачи!"
