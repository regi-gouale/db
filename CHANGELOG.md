# Changelog

Toutes les modifications notables apportées à ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2023-XX-XX

### Ajouté

- Configuration initiale du service PostgreSQL avec Docker Compose
- Service de backup automatique programmé avec cron
- Scripts de sauvegarde et de restauration de la base de données
- Configuration des volumes pour la persistance des données
- Paramètres d'optimisation PostgreSQL
- Mécanisme de rotation des sauvegardes basé sur la durée de rétention
- Documentation complète du projet

### Sécurité

- Authentification par mot de passe sécurisé
- Restrictions des privilèges avec `no-new-privileges`
- Limitation des permissions sur les fichiers de sauvegarde
- Variables d'environnement pour les données sensibles
