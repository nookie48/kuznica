cd $HOME/infernet-container-starter/deploy
docker compose down
sleep 3
sudo rm -rf docker-compose.yaml
wget https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Node/Ritual/docker-compose.yaml

docker-compose up --remove-orphans -d

docker rm -fv infernet-anvil  &>/dev/null
