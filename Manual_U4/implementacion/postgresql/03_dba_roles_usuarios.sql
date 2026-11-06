-- ==========================================================================
-- PostgreSQL · Roles de puesto y usuarios
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Usuarios y roles > Creación de roles y usuarios en PostgreSQL
-- ==========================================================================

SET client_encoding = 'UTF8';
SET ROLE rol_admin_bd;

CREATE ROLE rol_gerente   NOLOGIN;
CREATE ROLE rol_ejecutivo NOLOGIN;
CREATE ROLE rol_tesoreria NOLOGIN;
CREATE ROLE rol_auditor   NOLOGIN;
CREATE ROLE rol_respaldo  NOLOGIN;

-- Cuentas compartidas de operación (una por rol)
CREATE USER op_gerente   WITH PASSWORD 'OpGerente#2026'   IN ROLE rol_gerente;
CREATE USER op_ejecutivo WITH PASSWORD 'OpEjecutivo#2026' IN ROLE rol_ejecutivo;
CREATE USER op_tesoreria WITH PASSWORD 'OpTesoreria#2026' IN ROLE rol_tesoreria;

-- Cuentas administrativas (una por persona o herramienta)
CREATE USER enovoa   WITH PASSWORD 'Enovoa#2026'   IN ROLE rol_auditor;
CREATE USER respaldo WITH PASSWORD 'Respaldo#2026' IN ROLE rol_respaldo;

RESET ROLE;
