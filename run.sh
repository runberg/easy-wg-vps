#!/bin/sh

# -----------------------------------
# UPDATE THE SERVER
# -----------------------------------

echo "Updating the server..."

apt update
apt upgrade -y
apt full-upgrade -y
apt autoremove -y

echo "Server updated."

# -----------------------------------
# INSTALL DOCKER & DOCKER COMPOSE
# -----------------------------------

echo "Installing docker..."

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
apt install docker.io docker-*-plugin

# -----------------------------------
# GET COMPOSE FILE AND UPDATING
# -----------------------------------

echo "Getting the docker compose file..."

read -p "Enter the domain name for your server: " domain
read -p "Enter the email address for LetsEncrypt: " email

echo -n "Enter the password for the WG Admin page: "
read -s pw

wget https://raw.githubusercontent.com/runberg/easy-wg-vps/main/docker-compose.yml

sed -i -e 's/<DOMAIN>/$domain/g' /docker-compose.yml
sed -i -e 's/<PASSWORD>/$pw/g' /docker-compose.yml
sed -i -e 's/<EMAIL>/$email/g' /docker-compose.yml

# -----------------------------------
# STARTING CONTAINER
# -----------------------------------

echo "Starting containers..."

docker network create traefik_network
docker compose up -d

# -----------------------------------
# TO DO:
#   -  Create folders for LetsEncrypt & WireGuard and map accordingly in Docker Compose
#   -  Change WG port?
# -----------------------------------
