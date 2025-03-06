# PostgreSQL Database Environment

Cette solution fournit un environnement PostgreSQL standardisé et conteneurisé, facile à déployer et à gérer. L'environnement est configuré avec des backups automatiques et des paramètres optimisés pour PostgreSQL.

## Fonctionnalités

- **Base de données PostgreSQL 15** basée sur Alpine Linux
- **Persistance des données** grâce aux volumes Docker
- **Sauvegardes automatiques** programmées avec rotation
- **Interface d'administration pgAdmin** pour gérer visuellement la base de données
- **Paramètres de performance** optimisés et configurables
- **Healthcheck** pour surveiller l'état de la base de données
- **Configuration sécurisée** avec isolation et restrictions de privilèges
- **Scripts utilitaires** pour la maintenance et la gestion des utilisateurs

## Prérequis

- Docker Engine (version 19.03.0+)
- Docker Compose (version 1.29.0+)

## Installation et démarrage

1. Clonez ce dépôt :

   ```bash
   git clone https://github.com/regi-gouale/db.git
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

#### Paramètres de performance

- `POSTGRES_SHARED_BUFFERS` : Taille des buffers partagés (défaut : 256MB)
- `POSTGRES_EFFECTIVE_CACHE_SIZE` : Taille de cache effective (défaut : 768MB)
- `POSTGRES_MAX_CONNECTIONS` : Nombre maximum de connexions simultanées (défaut : 100)
- `POSTGRES_WORK_MEM` : Mémoire allouée aux opérations de tri (défaut : 4MB)
- `POSTGRES_MAINTENANCE_WORK_MEM` : Mémoire pour les opérations de maintenance (défaut : 64MB)

#### Limites de ressources

- `POSTGRES_CPU_LIMIT` : Limite CPU pour le conteneur (défaut : 1)
- `POSTGRES_MEMORY_LIMIT` : Limite mémoire pour le conteneur (défaut : 1G)

#### Configuration des sauvegardes

- `BACKUP_RETENTION_DAYS` : Nombre de jours de conservation des sauvegardes (défaut : 7)
- `BACKUP_SCHEDULE` : Planification des sauvegardes au format cron (défaut : 0 2 \* \* \*)

#### Configuration de pgAdmin

- `PGADMIN_DEFAULT_EMAIL` : Email de connexion à pgAdmin (défaut : admin@example.com)
- `PGADMIN_DEFAULT_PASSWORD` : Mot de passe pgAdmin (modifiez cette valeur)
- `PGADMIN_PORT` : Port d'accès à l'interface pgAdmin (défaut : 5050)
- `PGADMIN_SERVER_MODE` : Mode serveur pour environnements multi-utilisateurs (défaut : False)
- `PGADMIN_MASTER_PASSWORD_REQUIRED` : Exiger un mot de passe maître (défaut : False)
- `PGADMIN_ENHANCED_COOKIE_PROTECTION` : Protection renforcée des cookies (défaut : True)

### Structure des dossiers

- `/backups` : Contient les sauvegardes de la base de données
- `/scripts` : Scripts d'utilitaires pour les sauvegardes et la maintenance
- `/init` : Scripts d'initialisation exécutés lors du premier démarrage

## Initialisation de la base de données

Les scripts SQL placés dans le dossier `init/` seront exécutés automatiquement lors de la première création de la base de données. Les scripts sont exécutés par ordre alphabétique, donc vous pouvez préfixer les noms de fichiers avec des nombres pour contrôler l'ordre d'exécution.

Un exemple de script `01-init.sql` est fourni pour illustrer comment créer des schémas, des tables, des index et des déclencheurs.

## Sauvegardes et restauration

### Configuration des sauvegardes

Les sauvegardes sont configurées pour s'exécuter automatiquement selon le planning défini dans la variable `BACKUP_SCHEDULE`.
Par défaut, les sauvegardes sont exécutées tous les jours à 2h du matin.

### Format des fichiers de sauvegarde

Les sauvegardes sont enregistrées sous le format `nomdelabd_AAAAMMJJ_HHMMSS.sql.gz` dans le dossier `/backups`.

### Restauration d'une sauvegarde

Pour restaurer une sauvegarde, utilisez le script de restauration fourni :

```bash
./scripts/restore.sh ./backups/votre_sauvegarde.sql.gz [nom_base_donnees]
```

Si le nom de la base de données n'est pas spécifié, la restauration se fera dans la base définie par la variable `POSTGRES_DB`.

### Exécution manuelle d'une sauvegarde

```bash
docker-compose exec backup /scripts/backup.sh
```

## Gestion des utilisateurs

Pour créer un utilisateur administrateur, utilisez le script fourni :

```bash
./scripts/create-admin-user.sh nom_utilisateur mot_de_passe
```

Cet utilisateur aura les privilèges nécessaires pour créer des bases de données, des rôles et gérer les données.

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

### Bonnes pratiques PostgreSQL

1. **Indexation** : Créez des index pour les colonnes fréquemment utilisées dans les requêtes WHERE, JOIN et ORDER BY
2. **Vacuum régulier** : Exécutez régulièrement VACUUM pour récupérer l'espace et améliorer les performances
3. **Statistiques** : Maintenez les statistiques à jour avec ANALYZE
4. **Partitionnement** : Pour les grandes tables, envisagez le partitionnement
5. **Monitoring** : Surveillez régulièrement les requêtes lentes avec pg_stat_statements

## Sécurité

- Les mots de passe sont stockés dans le fichier `.env` qui est exclu du versionnement via `.gitignore`
- La méthode d'authentification MD5 est utilisée pour les connexions
- Les fichiers de sauvegarde ont des permissions restreintes (chmod 600)
- Le service de base de données fonctionne avec des privilèges limités
- Les capacités Docker sont limitées au strict minimum (principe du moindre privilège)
- Le réseau utilise un subnet dédié pour isoler les services

## License

[MIT](LICENSE)
