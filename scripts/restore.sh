#!/bin/bash

# Script de restauration pour PostgreSQL
# Usage: ./restore.sh chemin/vers/backup.sql.gz [nom_base_données]

# Configuration
POSTGRES_HOST=${POSTGRES_HOST:-postgres}
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_DB=${POSTGRES_DB:-default}

# Vérification des arguments
if [ -z "$1" ]; then
    echo "Erreur: Chemin du fichier de backup non spécifié"
    echo "Usage: $0 chemin/vers/backup.sql.gz [nom_base_données]"
    exit 1
fi

BACKUP_FILE=$1

# Vérifier si le nom de la base est fourni en 2ème argument
if [ ! -z "$2" ]; then
    POSTGRES_DB=$2
fi

# Vérifier si le fichier existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Erreur: Le fichier $BACKUP_FILE n'existe pas"
    exit 1
fi

# Vérification de la présence des variables requises
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "POSTGRES_PASSWORD is not set. Please set it in your environment or .env file."
    exit 1
fi

echo "Restauration de la base $POSTGRES_DB depuis $BACKUP_FILE..."

# Restaurer la base de données à partir du backup
export PGPASSWORD=$POSTGRES_PASSWORD

# Créer la base si elle n'existe pas déjà
psql -h $POSTGRES_HOST -U $POSTGRES_USER -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | grep -q 1 || \
psql -h $POSTGRES_HOST -U $POSTGRES_USER -c "CREATE DATABASE $POSTGRES_DB"

# Restaurer les données
gunzip -c $BACKUP_FILE | psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB

# Vérification du succès de la restauration
if [ $? -eq 0 ]; then
    echo "Restauration terminée avec succès vers la base $POSTGRES_DB"
else
    echo "La restauration a échoué"
    exit 1
fi
