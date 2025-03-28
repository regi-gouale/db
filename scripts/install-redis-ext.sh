#!/bin/bash

# Script pour installer l'extension Redis Manager pour pgAdmin
# Ce script doit être exécuté à l'intérieur du conteneur pgAdmin

set -e

echo "Installation de l'extension Redis Manager pour pgAdmin..."

# Variables
PGADMIN_EXTENSION_DIR="/var/lib/pgadmin/storage/extensions"
REDIS_EXT_NAME="redis_manager"
REDIS_EXT_VERSION="0.2.0"
DOWNLOAD_URL="https://github.com/jdelprete/pgadmin4_redis_manager/archive/refs/tags/v${REDIS_EXT_VERSION}.tar.gz"

# Créer le répertoire d'extensions si nécessaire
mkdir -p $PGADMIN_EXTENSION_DIR

# Installer les dépendances nécessaires (utilisation de apk pour Alpine Linux)
apk update
apk add --no-cache wget python3 py3-pip

# Télécharger et installer l'extension
cd /tmp
wget $DOWNLOAD_URL -O redis_manager.tar.gz
tar -xzf redis_manager.tar.gz
mv pgadmin4_redis_manager-${REDIS_EXT_VERSION} $PGADMIN_EXTENSION_DIR/$REDIS_EXT_NAME

# Installer les dépendances Python
cd $PGADMIN_EXTENSION_DIR/$REDIS_EXT_NAME
pip3 install -r requirements.txt

# Activer l'extension
echo "Activation de l'extension Redis Manager..."
echo "{\"enabled\": true}" > $PGADMIN_EXTENSION_DIR/$REDIS_EXT_NAME/enabled.json

echo "Installation terminée. L'extension Redis Manager est maintenant disponible dans pgAdmin."