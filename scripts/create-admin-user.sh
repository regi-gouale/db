#!/bin/bash

# Script pour créer un utilisateur administrateur PostgreSQL
# Usage: ./create-admin-user.sh nom_utilisateur mot_de_passe

# Configuration
POSTGRES_HOST=${POSTGRES_HOST:-postgres}
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_DB=${POSTGRES_DB:-default}

# Vérification des arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Erreur: Nom d'utilisateur ou mot de passe non spécifié"
    echo "Usage: $0 nom_utilisateur mot_de_passe"
    exit 1
fi

ADMIN_USER=$1
ADMIN_PASSWORD=$2

# Vérification de la présence des variables requises
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "POSTGRES_PASSWORD is not set. Please set it in your environment or .env file."
    exit 1
fi

echo "Création de l'utilisateur administrateur '$ADMIN_USER'..."

export PGPASSWORD=$POSTGRES_PASSWORD

# Créer l'utilisateur avec privilèges élevés
psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB << EOF
-- Créer l'utilisateur s'il n'existe pas
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$ADMIN_USER') THEN
        CREATE USER $ADMIN_USER WITH PASSWORD '$ADMIN_PASSWORD';
    ELSE
        ALTER USER $ADMIN_USER WITH PASSWORD '$ADMIN_PASSWORD';
    END IF;
END
\$\$;

-- Accorder les privilèges
ALTER USER $ADMIN_USER WITH CREATEDB CREATEROLE;
GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $ADMIN_USER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $ADMIN_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $ADMIN_USER;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO $ADMIN_USER;
EOF

# Vérification du succès de l'opération
if [ $? -eq 0 ]; then
    echo "L'utilisateur administrateur '$ADMIN_USER' a été créé avec succès"
else
    echo "La création de l'utilisateur administrateur a échoué"
    exit 1
fi

echo "N'oubliez pas de sécuriser les informations d'identification de cet utilisateur administrateur !"
