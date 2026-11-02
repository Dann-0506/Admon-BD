-- ==========================================================================
-- MySQL · Rol del DBA
-- Ejecuta:  root
-- Conexión: sin base de datos
-- Origen:   Usuarios y roles > Creación de roles y usuarios en MySQL
-- ==========================================================================

SET NAMES utf8mb4;
CREATE ROLE rol_admin_bd;
GRANT ALL PRIVILEGES ON inversiones.* TO rol_admin_bd WITH GRANT OPTION;
GRANT CREATE ROLE, CREATE USER, ROLE_ADMIN ON *.* TO rol_admin_bd;

CREATE USER 'dlandero'@'%' IDENTIFIED BY 'Dlandero#2026'
  DEFAULT ROLE rol_admin_bd;
