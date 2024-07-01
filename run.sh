#!/bin/sh

# -----------------------------------
# UPDATE THE SERVER
# -----------------------------------

echo "Updating the server..."

apt-get update
apt-get upgrade -y
apt-get full-upgrade -y
apt-get autoremove -y

echo "Server updated."

# -----------------------------------
# GENERAL MAINTENANCE AND SETUP
# -----------------------------------

echo "Setting up server ... "

echo -n "Paste public SSH key for login (Optional - Press enter to ignore): "
read -s ssh
echo ""

if [ -z "${ssh}" ]; then
  sed -i -e '$a '"$ssh"'' .ssh/authorized_keys 
  echo "SSH key was added."
fi

while true; do
    read -p "Enable unattended upgrades? " auto
    case $auto in
        [Yy]* ) 
             apt-get install unattended-upgrades -y
             ENABLE=$'APT::Periodic::Update-Package-Lists "1";\nAPT::Periodic::Unattended-Upgrade "1";\nAPT::Periodic::AutoCleanInterval "7";'
             echo "$ENABLE" > /etc/apt/apt.conf.d/20auto-upgrades  
             ;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Server configured."

# -----------------------------------
# INSTALL DOCKER & DOCKER COMPOSE
# -----------------------------------

echo "Installing docker..."

apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
chmod a+r /etc/apt/keyrings/docker.asc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd containerd.io runc; do sudo apt-get remove $pkg; done
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

sed -i -e 's/<DOMAIN>/'"$domain"'/g' docker-compose.yml
sed -i -e 's/<PASSWORD>/'"$pw"'/g' docker-compose.yml
sed -i -e 's/<EMAIL>/'"$email"'/g' docker-compose.yml

# -----------------------------------
# STARTING CONTAINER
# -----------------------------------

echo "Starting containers..."

mkdir wireguard_data traefik_letsencrypt_data
docker network create traefik_network
docker compose up -d

# -----------------------------------
# TO DO:
#   -  Auto update server and docker image
#   -  Change WG port?
# -----------------------------------
