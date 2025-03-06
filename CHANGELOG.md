# Changelog

Toutes les modifications notables apportées à ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-07

### Ajouté

- Configuration initiale du service PostgreSQL 15 avec Docker Compose
- Service de backup automatique programmé avec cron
- Scripts d'utilitaires :
  - `backup.sh` pour les sauvegardes manuelles et automatiques
  - `restore.sh` pour la restauration des sauvegardes
  - `create-admin-user.sh` pour la création d'utilisateurs avec privilèges
  - `entrypoint-backup.sh` pour la gestion des sauvegardes programmées
  - `setup.sh` pour l'initialisation automatique de l'environnement
- Configuration des volumes pour la persistance des données
- Paramètres d'optimisation PostgreSQL avancés
- Mécanisme de rotation des sauvegardes basé sur la durée de rétention
- Documentation complète du projet avec README détaillé
- Interface d'administration pgAdmin pour gérer visuellement la base de données
- Connexion automatique pgAdmin vers PostgreSQL
- Script de configuration automatique de serveur pour pgAdmin
- Exemple de script SQL d'initialisation avec création de schéma, tables et triggers
- Fichier .env.example pour faciliter la configuration initiale

### Modifié

- Amélioration des configurations Docker avec limites de ressources
- Optimisation des healthchecks pour tous les services
- Organisation améliorée des répertoires et des fichiers de configuration

### Sécurité

- Authentification par mot de passe sécurisé
- Restrictions des privilèges avec `no-new-privileges`
- Configuration limitée des capacités Docker (principe du moindre privilège)
- Limitation des permissions sur les fichiers de sauvegarde (chmod 600)
- Variables d'environnement pour les données sensibles
- Protection renforcée des cookies pour pgAdmin
- Configuration réseau isolée avec subnet dédié
- Exclusion des fichiers sensibles du versionnement via .gitignore
