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
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y

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