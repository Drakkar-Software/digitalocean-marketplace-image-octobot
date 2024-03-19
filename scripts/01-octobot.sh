#!/bin/bash

# Docker from https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh --dry-run

# Docker compose from https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# Download OctoBot docker compose file
curl -fs https://raw.githubusercontent.com/Drakkar-Software/OctoBot/master/docker-compose.yml -o docker-compose.yml

# Start OctoBot
docker compose up -d
