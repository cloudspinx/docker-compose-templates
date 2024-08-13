#/bin/bash
# Source env file
source .env

# Allow containers to use folders without perms error
mkdir -p $LETSENCRYPT_PATH $WEBROOT_PATH
chmod 0777 $LETSENCRYPT_PATH $WEBROOT_PATH

# Copy SSL files over
cd ..
mkdir -p ./keycloak-certs
cp -f certbot/letsencrypt/live/$DOMAIN/fullchain.pem ./keycloak-certs
cp -f certbot/letsencrypt/live/$DOMAIN/privkey.pem ./keycloak-certs
chmod -R 0644 ./keycloak-certs
