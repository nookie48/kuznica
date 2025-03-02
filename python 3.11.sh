#!/bin/bash
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y 
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3.11-dev
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
sudo update-alternatives --config python3
sudo apt install -y python3-pip
