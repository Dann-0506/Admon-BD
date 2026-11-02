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

CREATE USER dmejia   WITH PASSWORD 'Dmejia#2026'   IN ROLE rol_gerente;
CREATE USER pzuniga  WITH PASSWORD 'Pzuniga#2026'  IN ROLE rol_ejecutivo;
CREATE USER xzaleta  WITH PASSWORD 'Xzaleta#2026'  IN ROLE rol_tesoreria;
CREATE USER enovoa   WITH PASSWORD 'Enovoa#2026'   IN ROLE rol_auditor;
CREATE USER respaldo WITH PASSWORD 'Respaldo#2026' IN ROLE rol_respaldo;

RESET ROLE;
