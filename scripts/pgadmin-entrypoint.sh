#!/bin/bash

# Script pour ajouter des actions d'initialisation au démarrage de pgAdmin
# Ce script est conçu pour être exécuté comme un entrypoint ou comme une commande dans le conteneur pgAdmin

# Installer su-exec si nécessaire (alternative à gosu pour Alpine)
if ! command -v su-exec &> /dev/null; then
    echo "Installation de su-exec..."
    apk add --no-cache su-exec
fi

# Installer l'extension Redis Manager si elle n'est pas déjà installée
if [ -f "/pgadmin4/install-redis-ext.sh" ]; then
    echo "Installation de l'extension Redis pour pgAdmin..."
    chmod +x /pgadmin4/install-redis-ext.sh
    /pgadmin4/install-redis-ext.sh
fi

# Revenir à l'utilisateur pgadmin pour le fonctionnement normal du conteneur
if [ "$(id -u)" = "0" ]; then
    echo "Changement d'utilisateur vers pgadmin..."
    # Ajuster les droits des répertoires utilisés par pgAdmin
    chown -R 5050:5050 /var/lib/pgadmin
    
    # Démarrer pgAdmin avec l'utilisateur pgadmin
    exec su-exec pgadmin:5050 /entrypoint.sh "$@"
else
    # Si ce n'est pas root, exécuter directement
    exec /entrypoint.sh "$@"
fi