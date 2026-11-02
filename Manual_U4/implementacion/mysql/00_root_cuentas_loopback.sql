-- ==========================================================================
-- MySQL · Cuentas de loopback del superusuario
-- Ejecuta:  root
-- Conexión: antes de activar skip_name_resolve
-- Origen:   Configuración del entorno > MySQL > Conexión
-- ==========================================================================

SET NAMES utf8mb4;
-- Superusuario, antes de activar skip_name_resolve
CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY '********';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
CREATE USER 'root'@'::1' IDENTIFIED BY '********';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'::1' WITH GRANT OPTION;
