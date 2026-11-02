-- ==========================================================================
-- MySQL · Roles de puesto, usuarios y privilegios de respaldo
-- Ejecuta:  dlandero
-- Conexión: sin base de datos
-- Origen:   Usuarios y roles > Creación de roles y usuarios en MySQL
-- ==========================================================================

SET NAMES utf8mb4;
CREATE ROLE rol_gerente, rol_ejecutivo, rol_tesoreria,
            rol_auditor, rol_respaldo;

CREATE USER 'dmejia'@'%'   IDENTIFIED BY 'Dmejia#2026'
  DEFAULT ROLE rol_gerente;
CREATE USER 'pzuniga'@'%'  IDENTIFIED BY 'Pzuniga#2026'
  DEFAULT ROLE rol_ejecutivo;
CREATE USER 'xzaleta'@'%'  IDENTIFIED BY 'Xzaleta#2026'
  DEFAULT ROLE rol_tesoreria;
CREATE USER 'enovoa'@'%'   IDENTIFIED BY 'Enovoa#2026'
  DEFAULT ROLE rol_auditor;
CREATE USER 'respaldo'@'%' IDENTIFIED BY 'Respaldo#2026'
  DEFAULT ROLE rol_respaldo;

-- DBA: privilegios sobre la base de datos
GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES
  ON inversiones.* TO rol_respaldo;
