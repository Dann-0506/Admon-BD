-- ==========================================================================
-- MySQL · Tablespaces (primera instancia)
-- Ejecuta:  root
-- Conexión: sin base de datos
-- Origen:   Tablespaces > MySQL > Creación de los tablespaces
-- ==========================================================================

SET NAMES utf8mb4;
-- Ejecutado por root
CREATE TABLESPACE ts_catalogos
  ADD DATAFILE 'C:/tablespaces/mysql1/catalogos/ts_catalogos.ibd';
CREATE TABLESPACE ts_operacion
  ADD DATAFILE 'C:/tablespaces/mysql1/operacion/ts_operacion.ibd';
CREATE TABLESPACE ts_bitacora
  ADD DATAFILE 'C:/tablespaces/mysql1/bitacora/ts_bitacora.ibd';
