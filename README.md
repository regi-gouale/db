# PostgreSQL Database Environment

Cette solution fournit un environnement PostgreSQL standardisé et conteneurisé, facile à déployer et à gérer. L'environnement est configuré avec des backups automatiques et des paramètres optimisés pour PostgreSQL.

## Fonctionnalités

- **Base de données PostgreSQL 15** basée sur Alpine Linux
- **Persistance des données** grâce aux volumes Docker
- **Sauvegardes automatiques** programmées avec rotation
- **Interface d'administration pgAdmin** pour gérer visuellement la base de données
- **Service Redis 7** pour le cache et le stockage de données en mémoire
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

2. Exécutez le script de configuration :

   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. Démarrez l'environnement :
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

## Administration de la base de données

### Interface Web pgAdmin

Une interface d'administration pgAdmin est disponible pour gérer visuellement votre base de données PostgreSQL.

1. Accédez à l'interface via votre navigateur web : http://localhost:5050 (ou le port que vous avez configuré)
2. Connectez-vous avec les identifiants définis dans votre fichier .env :
   - Email : valeur de PGADMIN_DEFAULT_EMAIL
   - Mot de passe : valeur de PGADMIN_DEFAULT_PASSWORD
3. **Le serveur PostgreSQL est automatiquement configuré** et prêt à être utilisé dans la liste des serveurs

### Connexion automatique

La connexion au serveur PostgreSQL est automatiquement configurée dans pgAdmin. Vous n'avez pas besoin de saisir les paramètres de connexion manuellement.

Si vous modifiez les paramètres PostgreSQL dans le fichier .env, exécutez à nouveau le script de configuration pour mettre à jour la connexion pgAdmin :

```bash
./scripts/setup.sh
```

## Configuration de Redis

Le service Redis est configuré pour fonctionner comme un cache et un stockage en mémoire pour vos applications.

### Variables d'environnement Redis

Modifiez ces paramètres dans le fichier `.env` pour personnaliser votre instance Redis :

- `REDIS_PORT` : Port exposé pour Redis (défaut : 6379)
- `REDIS_PASSWORD` : Mot de passe d'authentification Redis (modifiez cette valeur)
- `REDIS_MAXMEMORY` : Limite de mémoire utilisée par Redis (défaut : 256mb)
- `REDIS_MAXMEMORY_POLICY` : Politique d'éviction quand la mémoire est pleine (défaut : allkeys-lru)
- `REDIS_APPENDONLY` : Activation de la persistance sur disque (défaut : yes)
- `REDIS_APPENDFSYNC` : Fréquence de synchronisation des données (défaut : everysec)
- `REDIS_CPU_LIMIT` : Limite CPU pour le conteneur Redis (défaut : 0.5)
- `REDIS_MEMORY_LIMIT` : Limite mémoire pour le conteneur Redis (défaut : 512M)

### Connexion à Redis

Pour vous connecter à l'instance Redis depuis la ligne de commande :

```bash
docker-compose exec redis redis-cli -a $(grep REDIS_PASSWORD .env | cut -d '=' -f2)
```

### Politiques d'éviction

La configuration par défaut utilise `allkeys-lru`, qui supprime les clés les moins récemment utilisées lorsque la mémoire est pleine. Les autres options disponibles sont :

- `volatile-lru` : Supprime les clés moins récemment utilisées avec une date d'expiration
- `volatile-ttl` : Supprime les clés avec le TTL le plus court
- `volatile-random` : Supprime des clés aléatoires avec une date d'expiration
- `allkeys-random` : Supprime des clés aléatoires
- `noeviction` : Renvoie des erreurs lorsque la mémoire est pleine

### Persistance des données

Redis est configuré avec la persistance activée via le mode AOF (Append Only File), ce qui garantit que les données ne sont pas perdues en cas de redémarrage du service.

## License

[MIT](LICENSE)
