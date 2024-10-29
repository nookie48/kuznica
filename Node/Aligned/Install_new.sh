#!/bin/bash

echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
echo "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
echo "Обновление успешно завершено."

echo "Устанавливаем необходимое ПО"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Go.sh | bash
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Rust.sh | bash
source $HOME/.profile
source "$HOME/.cargo/env"

# Устанавливаем Foundry
cd $HOME
mkdir -p foundry
cd foundry
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
echo 'export PATH="$PATH:/root/.foundry/bin"' >> .profile
source .profile

foundryup

echo "*******************************************************"
echo "Скачиваем и импортируем кошелек по private key"
echo "*******************************************************"

cd $HOME
git clone https://github.com/yetanotherco/aligned_layer.git && cd aligned_layer
cast wallet import --interactive wallet

echo "*******************************************************"
echo "Устанавливаем дополнительные зависимости и проходим квиз. Правильные ответы: Nakamoto, Pacific, Green"
echo "*******************************************************"

cd $HOME/aligned_layer/examples/zkquiz
make answer_quiz KEYSTORE_PATH=$HOME/.foundry/keystores/wallet

echo "-----------------------------------------------------------------------------"
echo "Убираем за собой, удаляем данные после деплоя"
echo "-----------------------------------------------------------------------------"

cd $HOME
rm -rf $HOME/aligned_layer
rm -rf $HOME/.foundry/keystores/wallet

echo "Все сделано! Пора переходить к следующему аккаунту!"
