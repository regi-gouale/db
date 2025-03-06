#!/bin/bash

# Installer cron
apk add --no-cache dcron

# Assurer que les scripts sont exécutables
chmod +x /scripts/backup.sh

# Créer le fichier crontab
echo "${BACKUP_SCHEDULE} /scripts/backup.sh > /proc/1/fd/1 2>&1" > /etc/crontabs/root

# Afficher le planning programmé
echo "Backup scheduled with cron: ${BACKUP_SCHEDULE}"
echo "Current crontab configuration:"
cat /etc/crontabs/root

# Exécuter une première sauvegarde immédiatement
echo "Performing initial backup..."
/scripts/backup.sh

# Démarrer cron en avant-plan
echo "Starting cron daemon..."
crond -f -d 8
