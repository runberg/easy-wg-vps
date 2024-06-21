#!/bin/sh

# -----------------------------------
# UPDATE THE SERVER
# -----------------------------------

apt update
apt upgrade
apt full-upgrade
apt autoremove

# -----------------------------------
# INSTALL DOCKER & DOCKER COMPOSE
# -----------------------------------

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y

# -----------------------------------
# GET COMPOSE FILE AND START
# -----------------------------------

wget https://raw.githubusercontent.com/runberg/easy-wg-vps/main/docker-compose.yml
docker network create traefik_network
docker compose up -d
