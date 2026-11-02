-- ==========================================================================
-- PostgreSQL, segunda instancia · Tablespaces (segunda instancia)
-- Ejecuta:  postgres
-- Conexión: puerto 5434, base postgres
-- Origen:   Tablespaces > PostgreSQL, con pg2 en lugar de pg1
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Ejecutado por postgres
CREATE TABLESPACE ts_catalogos OWNER rol_admin_bd
  LOCATION 'C:/tablespaces/pg2/catalogos';
CREATE TABLESPACE ts_operacion OWNER rol_admin_bd
  LOCATION 'C:/tablespaces/pg2/operacion';
CREATE TABLESPACE ts_bitacora OWNER rol_admin_bd
  LOCATION 'C:/tablespaces/pg2/bitacora';
