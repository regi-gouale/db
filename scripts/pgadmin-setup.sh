#!/bin/bash

# Script pour configurer la connexion PostgreSQL dans pgAdmin
# Ce script crée un fichier de configuration de serveurs pour pgAdmin

# Variables d'environnement
PGADMIN_SETUP_EMAIL=${PGADMIN_DEFAULT_EMAIL:-admin@example.com}
PGADMIN_SETUP_PASSWORD=${PGADMIN_DEFAULT_PASSWORD:-admin}
POSTGRES_HOST=${POSTGRES_HOST:-postgres}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-password}
POSTGRES_DB=${POSTGRES_DB:-default}

# Vérification des variables d'environnement
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "POSTGRES_PASSWORD is not set. Please set it in your environment or .env file."
    exit 1
fi

# Générer le fichier JSON de configuration de serveur
SERVER_JSON=$(cat <<EOF
{
    "Servers": {
        "1": {
            "Name": "PostgreSQL Server",
            "Group": "Servers",
            "Host": "${POSTGRES_HOST}",
            "Port": ${POSTGRES_PORT},
            "MaintenanceDB": "${POSTGRES_DB}",
            "Username": "${POSTGRES_USER}",
            "SSLMode": "prefer",
            "PassFile": "/pgpass",
            "Comment": "PostgreSQL Server configuré automatiquement"
        }
    }
}
EOF
)

# Créer le répertoire de configuration pgAdmin
mkdir -p ./pgadmin/servers/

# Écrire le fichier de configuration
echo "$SERVER_JSON" > ./pgadmin/servers/servers.json
chmod 600 ./pgadmin/servers/servers.json

# Créer le fichier pgpass (stockage sécurisé du mot de passe PostgreSQL)
echo "${POSTGRES_HOST}:${POSTGRES_PORT}:${POSTGRES_DB}:${POSTGRES_USER}:${POSTGRES_PASSWORD}" > ./pgadmin/pgpass
chmod 600 ./pgadmin/pgpass

echo "Configuration pgAdmin terminée. Serveur PostgreSQL ajouté automatiquement."
echo "Accédez à pgAdmin via http://localhost:${PGADMIN_PORT:-5050}"
echo "Email: ${PGADMIN_SETUP_EMAIL}"
echo "Mot de passe: ${PGADMIN_SETUP_PASSWORD}"
