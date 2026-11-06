-- ==========================================================================
-- MySQL · Roles de puesto, usuarios y privilegios de respaldo
-- Ejecuta:  dlandero
-- Conexión: sin base de datos
-- Origen:   Usuarios y roles > Creación de roles y usuarios en MySQL
-- ==========================================================================

SET NAMES utf8mb4;
CREATE ROLE rol_gerente, rol_ejecutivo, rol_tesoreria,
            rol_auditor, rol_respaldo;

-- Cuentas compartidas de operación (una por rol)
CREATE USER 'op_gerente'@'%'   IDENTIFIED BY 'OpGerente#2026'
  DEFAULT ROLE rol_gerente;
CREATE USER 'op_ejecutivo'@'%' IDENTIFIED BY 'OpEjecutivo#2026'
  DEFAULT ROLE rol_ejecutivo;
CREATE USER 'op_tesoreria'@'%' IDENTIFIED BY 'OpTesoreria#2026'
  DEFAULT ROLE rol_tesoreria;

-- Cuentas administrativas (una por persona o herramienta)
CREATE USER 'enovoa'@'%'   IDENTIFIED BY 'Enovoa#2026'
  DEFAULT ROLE rol_auditor;
CREATE USER 'respaldo'@'%' IDENTIFIED BY 'Respaldo#2026'
  DEFAULT ROLE rol_respaldo;

-- DBA: privilegios sobre la base de datos
GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES
  ON inversiones.* TO rol_respaldo;
