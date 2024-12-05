#!/bin/bash

sudo systemctl stop cysic-verifier

cd /root/cysic-verifier/data/

rm -r cysic-verifier.db

cd $home

bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Node/Cysic/Install%20node.sh)
