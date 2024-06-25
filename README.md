## Desciption ##

This is a quick and simple script to install [WG-Easy](https://github.com/wg-easy/wg-easy) on a clean VPS.

The script will update the VPS and install all dependencies, before installing WireGuard.
For WireGurad, WG-Easy is used. WG-Easy is installed using Docker Compose. For the admin interface SSL (LetsEncrypt) and Traefik is being used.

## Installation ##

Simply run the following command to setup everything:

```
bash <(wget -qO- https://raw.githubusercontent.com/runberg/easy-wg-vps/main/run.sh)
```
Once the scipt has completed the installation you will be able to access the WireGuard admin page on https://yourdomain.com




