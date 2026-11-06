-- ==========================================================================
-- MySQL · Privilegios sobre la instancia
-- Ejecuta:  root
-- Conexión: sin base de datos
-- Origen:   Usuarios y roles (respaldo) y Bitácora > MySQL
-- ==========================================================================

SET NAMES utf8mb4;
-- Superusuario: privilegios sobre la instancia
GRANT PROCESS, SHOW_ROUTINE ON *.* TO rol_respaldo;

-- Ejecutado por root
GRANT SELECT ON performance_schema.threads TO rol_admin_bd;
GRANT SELECT ON mysql.role_edges TO rol_admin_bd;
