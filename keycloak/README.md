# Docker Compose files for running Keycloak server with SSL - Let's Encrypt

Welcome to the "Docker Compose files for running Keycloak server with SSL - Let's Encrypt" repository!

This repository contains Docker Compose configurations for setting up a Keycloak server with SSL encryption using Let's Encrypt. Keycloak is an open-source identity and access management solution that provides single sign-on (SSO), user federation, and social login among many other features. Using Docker Compose simplifies the deployment process by managing multiple containers and their dependencies, ensuring a streamlined setup.

## What's Included:
- **Docker Compose Files**: Compose files for setting up Keycloak, Certbot for Let's Encrypt.
- **Certbot Integration**: Automated scripts for obtaining and renewing SSL certificates.
- **Nginx Configuration**: Pre-configured Nginx setup for handling HTTPS traffic.
- **Environment Variables**: Sample `.env` file to easily configure domain names, email addresses, and other settings.

## Install Docker

Start with the installation of Docker or Podman:

```bash
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker --version
docker compose version
```

For Podman refer to OS official documentation:

```bash
# RHEL based systems
sudo dnf -y install podman
sudo dnf install -y python3-pip
sudo pip3 install podman-compose

# Debian based systems
sudo apt update && sudo apt install podman
sudo apt install python3-pip
sudo pip3 install podman-compose
```

## Create keycloak network
```bash
docker network create keycloak||podman etwork create keycloak
```

You can check network information:

```bash
docker network inspect  keycloak
```

## Running Keycloak without SSL

Create a new `docker-compose.yaml` file from template provided:

```bash
cp docker-compose-no-ssl.yaml docker-compose.yaml
```

Create `.env` environment file:

```bash
cp docker.env .env
```

Customize the default values - at least for `yourdomain.com` (domain name used by keycloak, mostly it will be a sub-domain 

```bash
KC_HOSTNAME=yourdomain.com
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=Str0ngAdminPassw0rD
KC_DB_PASSWORD=StrongDBPassword
```

You can also review compose file and adjust as you see suitable:

Once done start the services:

```bash
docker compose up -d
```

Logs:

```bash
docker logs postgres-db
docker logs keycloak
```

## Generating Let's Encrypt SSL

Go to `certbot` directory:

```bash
cd certbot
```

Create env file and configure your options.

```bash
cp docker-env .env
vim .env
```

Make sure you set correct domain and email:
```bash
EMAIL=youremail@domain.com
DOMAIN=yourdomain.com
```

Edit the `nginx.conf` file and set your domain for server name:

```bash
server_name keycloak.domain.com;
```

Start certbot container service to obtail Let's Encryot cert and key 

```bash
docker compose up
```

Once done kill / cancel with [ctrl+c]

Set directory permissions and copy ssl files to `../keycloak-certs`:

```bash
bash set_perms.sh
```

Restart Keycloak services to use new certs.

```bash
cd ..
docker compose down
docker compose up -d
```

You can now access Keycloak at `http://yourdomain:8443`

## Renewing Let's Encrypt SSL

Under `certbot` directory we provided a script `ssl_renew.sh` which you can use to renew certs:

```bash
bash ssl_renew.sh
```

Remember to restart Keycloak services after renewal.
