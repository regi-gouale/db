# PostgreSQL Database Environment

Cette solution fournit un environnement PostgreSQL standardisé et conteneurisé, facile à déployer et à gérer. L'environnement est configuré avec des backups automatiques et des paramètres optimisés pour PostgreSQL.

## Fonctionnalités

- **Base de données PostgreSQL 15** basée sur Alpine Linux
- **Persistance des données** grâce aux volumes Docker
- **Sauvegardes automatiques** programmées avec rotation
- **Paramètres de performance** optimisés et configurables
- **Healthcheck** pour surveiller l'état de la base de données
- **Configuration sécurisée** avec isolation et restrictions de privilèges

## Prérequis

- Docker Engine (version 19.03.0+)
- Docker Compose (version 1.29.0+)

## Installation et démarrage

1. Clonez ce dépôt :

   ```bash
   git clone https://github.com/username/db.git
   cd db
   ```

2. Copiez le fichier .env.example en .env et modifiez les variables selon vos besoins :

   ```bash
   cp .env.example .env
   ```

3. Rendez les scripts exécutables :

   ```bash
   chmod +x scripts/*.sh
   ```

4. Démarrez l'environnement :
   ```bash
   docker-compose up -d
   ```

## Configuration

### Variables d'environnement

Modifiez le fichier `.env` pour personnaliser la configuration :

- `POSTGRES_USER` : Nom d'utilisateur PostgreSQL (défaut : postgres)
- `POSTGRES_PASSWORD` : Mot de passe PostgreSQL (modifiez cette valeur)
- `POSTGRES_DB` : Nom de la base de données (défaut : default)
- `POSTGRES_PORT` : Port exposé pour PostgreSQL (défaut : 5432)
- `POSTGRES_SHARED_BUFFERS` : Taille des buffers partagés (défaut : 256MB)
- `POSTGRES_EFFECTIVE_CACHE_SIZE` : Taille de cache effective (défaut : 768MB)
- `BACKUP_RETENTION_DAYS` : Nombre de jours de conservation des sauvegardes (défaut : 7)
- `BACKUP_SCHEDULE` : Planification des sauvegardes au format cron (défaut : 0 2 \* \* \*)

### Structure des dossiers

- `/backups` : Contient les sauvegardes de la base de données
- `/scripts` : Scripts d'utilitaires pour les sauvegardes et la maintenance
- `/init` : Scripts d'initialisation exécutés lors du premier démarrage

## Sauvegardes

### Configuration des sauvegardes

Les sauvegardes sont configurées pour s'exécuter automatiquement selon le planning défini dans la variable `BACKUP_SCHEDULE`.
Par défaut, les sauvegardes sont exécutées tous les jours à 2h du matin.

### Format des fichiers de sauvegarde

Les sauvegardes sont enregistrées sous le format `nomdelabd_AAAAMMJJ_HHMMSS.sql.gz` dans le dossier `/backups`.

### Restauration d'une sauvegarde

Pour restaurer une sauvegarde, utilisez la commande suivante :

```bash
gunzip -c ./backups/votre_sauvegarde.sql.gz | docker-compose exec -T postgres psql -U $POSTGRES_USER -d $POSTGRES_DB
```

## Maintenance

### Vérification de l'état du service

```bash
docker-compose ps
```

### Consultation des logs

```bash
docker-compose logs postgres
docker-compose logs backup
```

### Exécution manuelle d'une sauvegarde

```bash
docker-compose exec backup /scripts/backup.sh
```

## Sécurité

- Les mots de passe sont stockés dans le fichier `.env` qui est exclu du versionnement via `.gitignore`
- La méthode d'authentification MD5 est utilisée pour les connexions
- Les fichiers de sauvegarde ont des permissions restreintes (chmod 600)
- Le service de base de données fonctionne avec des privilèges limités

## License

[MIT](LICENSE)
