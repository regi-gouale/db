#!/bin/bash

# Configuration
BACKUP_DIR="/backups"
POSTGRES_HOST=${POSTGRES_HOST:-postgres}
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_DB=${POSTGRES_DB:-default}
BACKUP_RETENTION_DAYS=${BACKUP_RETENTION_DAYS:-7}

# Vérification de la présence des variables requises
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "POSTGRES_PASSWORD is not set. Exiting."
    exit 1
fi

# Création du répertoire de backup si nécessaire
mkdir -p $BACKUP_DIR

# Configuration de l'heure et du nom de fichier
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${POSTGRES_DB}_${TIMESTAMP}.sql.gz"

echo "Starting backup of database $POSTGRES_DB..."

# Export de la base de données et compression
export PGPASSWORD=$POSTGRES_PASSWORD
pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER $POSTGRES_DB | gzip > $BACKUP_FILE

# Vérification du succès de la sauvegarde
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
    
    # Configuration des permissions pour limiter l'accès au fichier de sauvegarde
    chmod 600 $BACKUP_FILE
    
    # Suppression des anciens backups selon la politique de rétention
    echo "Cleaning old backups (keeping last $BACKUP_RETENTION_DAYS days)..."
    find $BACKUP_DIR -name "${POSTGRES_DB}_*.sql.gz" -type f -mtime +$BACKUP_RETENTION_DAYS -delete
    
    echo "Backup process completed."
else
    echo "Backup failed."
    exit 1
fi

# Liste des sauvegardes disponibles
echo "Available backups:"
ls -lh $BACKUP_DIR
