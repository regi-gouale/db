#!/bin/bash

# Script d'initialisation pour configurer l'environnement
# Ce script configure les dossiers et fichiers nécessaires au bon fonctionnement du projet

echo "Configuration de l'environnement PostgreSQL..."

# Création des répertoires nécessaires
mkdir -p backups
mkdir -p init
mkdir -p config/pgadmin

# Vérifier si le fichier .env existe, sinon le créer depuis .env.example
if [ ! -f .env ]; then
    echo "Création du fichier .env à partir de .env.example..."
    cp .env.example .env
    echo "Veuillez éditer le fichier .env pour configurer vos paramètres personnalisés"
fi

# Réglage des permissions des scripts
chmod +x scripts/*.sh

# Configuration du fichier servers.json pour pgAdmin
echo "Configuration de la connexion pgAdmin..."

# Récupérer les variables depuis .env
source .env

# Créer le fichier de configuration pgAdmin
cat > config/pgadmin/servers.json << EOF
{
    "Servers": {
        "1": {
            "Name": "PostgreSQL Local",
            "Group": "Servers",
            "Host": "postgres",
            "Port": $POSTGRES_PORT,
            "MaintenanceDB": "$POSTGRES_DB",
            "Username": "$POSTGRES_USER",
            "SSLMode": "prefer",
            "Comment": "Connexion automatique vers PostgreSQL"
        },
        "2": {
            "Name": "Redis Local",
            "Group": "Redis",
            "Host": "redis",
            "Port": $REDIS_PORT,
            "Username": "",
            "Password": "$REDIS_PASSWORD",
            "Comment": "Connexion automatique vers Redis cache",
            "ServerType": "redis"
        }
    }
}
EOF

echo "Configuration terminée avec succès !"
echo "Pour lancer l'environnement, exécutez : docker-compose up -d"
echo "Accès à pgAdmin : http://localhost:$PGADMIN_PORT"
echo "  - Email: $PGADMIN_DEFAULT_EMAIL"
echo "  - Mot de passe: Voir dans votre fichier .env (variable PGADMIN_DEFAULT_PASSWORD)"
echo "  - Redis et PostgreSQL seront automatiquement configurés dans pgAdmin"
echo ""
echo "Note: Lors du premier démarrage, l'extension Redis pour pgAdmin sera installée automatiquement."
