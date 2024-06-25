#!/bin/sh

# -----------------------------------
# UPDATE THE SERVER
# -----------------------------------

echo "Updating the server..."

#apt-get update
#apt-get upgrade -y
#apt-get full-upgrade -y
#apt-get autoremove -y

echo "Server updated."

# -----------------------------------
# INSTALL DOCKER & DOCKER COMPOSE
# -----------------------------------

echo "Installing docker..."

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
apt-get install docker.io docker-*-plugin -y

# -----------------------------------
# GET COMPOSE FILE AND UPDATING
# -----------------------------------

echo "Getting the docker compose file..."

wget "https://raw.githubusercontent.com/runberg/easy-wg-vps/main/docker-compose.yml"

read -p "Enter the domain name for your server: " domain
read -p "Enter the email address for LetsEncrypt: " email

echo -n "Enter the password for the WG Admin page: "
read -s pw
echo ""

until [ -f docker-compose.yml ]
do
     echo "Docker file still downloading. Waiting ..."
     sleep 5
done

sed -i -e 's/<DOMAIN>/"$domain"/g' docker-compose.yml
echo "sed -i -e 's/<DOMAIN>/"$domain"/g' docker-compose.yml"
sed -i -e 's/<PASSWORD>/"$pw"/g' docker-compose.yml
sed -i -e 's/<EMAIL>/"$email"/g' docker-compose.yml

# -----------------------------------
# STARTING CONTAINER
# -----------------------------------

echo "Starting containers..."

mkdir wireguard_data traefik_letsencrypt_data
#docker network create traefik_network
#docker compose up -d

# -----------------------------------
# TO DO:
#   -  Create folders for LetsEncrypt & WireGuard and map accordingly in Docker Compose
#   -  Change WG port?
# -----------------------------------
