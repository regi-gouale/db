-- Exemple de script d'initialisation pour PostgreSQL
-- Ce script est exécuté automatiquement à la création de la base de données

-- Création d'un schéma d'application
CREATE SCHEMA IF NOT EXISTS app;

-- Création d'une table exemple
CREATE TABLE IF NOT EXISTS app.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Ajout d'index pour les recherches fréquentes
CREATE INDEX IF NOT EXISTS idx_users_username ON app.users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON app.users(email);

-- Commentaires sur les tables
COMMENT ON TABLE app.users IS 'Table des utilisateurs du système';
COMMENT ON COLUMN app.users.username IS 'Nom d''utilisateur unique';
COMMENT ON COLUMN app.users.email IS 'Email de l''utilisateur (unique)';
COMMENT ON COLUMN app.users.password_hash IS 'Hash du mot de passe (ne jamais stocker le mot de passe en clair)';

-- Fonction pour mettre à jour le timestamp de modification
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour mettre à jour le timestamp automatiquement
CREATE TRIGGER update_users_modtime
BEFORE UPDATE ON app.users
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();
