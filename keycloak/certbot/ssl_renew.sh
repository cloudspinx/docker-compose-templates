#!/bin/bash

# Load environment variables
source .env

# Stop containers
docker compose stop

# Run certbot renewal
docker compose run --rm certbot sh -c "certbot renew --webroot --webroot-path=/var/www/certbot"

# Check if certbot renewal was successful
if [ $? -eq 0 ]; then
	cd ../
	mkdir -p ./keycloak-certs
	# Copy the renewed certificates to the keycloak-certs directory
	mkdir -p ./keycloak-certs
	cp -f certbot/letsencrypt/live/$DOMAIN/fullchain.pem ./keycloak-certs
	cp -f certbot/letsencrypt/live/$DOMAIN/privkey.pem ./keycloak-certs
	chmod -R 0644 ./keycloak-certs
	echo "Certificates renewed and copied successfully."
else
	echo "Certificate renewal failed."
fi
