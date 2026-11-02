-- ==========================================================================
-- PostgreSQL · Tablespaces (primera instancia)
-- Ejecuta:  postgres
-- Conexión: base postgres
-- Origen:   Tablespaces > PostgreSQL > Creación de los tablespaces
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Ejecutado por postgres
CREATE TABLESPACE ts_catalogos OWNER rol_admin_bd
  LOCATION 'C:/tablespaces/pg1/catalogos';
CREATE TABLESPACE ts_operacion OWNER rol_admin_bd
  LOCATION 'C:/tablespaces/pg1/operacion';
CREATE TABLESPACE ts_bitacora OWNER rol_admin_bd
  LOCATION 'C:/tablespaces/pg1/bitacora';
