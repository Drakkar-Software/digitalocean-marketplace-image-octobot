#!/bin/bash

# Docker from https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

# Download OctoBot docker compose file
curl -fs https://raw.githubusercontent.com/Drakkar-Software/OctoBot/master/docker-compose.yml -o docker-compose.yml

# Start OctoBot
docker compose up -d
