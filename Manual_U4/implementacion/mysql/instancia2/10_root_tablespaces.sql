-- ==========================================================================
-- MySQL, segunda instancia · Tablespaces, sin ts_bitacora
-- Ejecuta:  root
-- Conexión: puerto 3308, sin base de datos
-- Origen:   Tablespaces > MySQL, con mysql2 en lugar de mysql1; ts_bitacora no se crea
-- ==========================================================================

SET NAMES utf8mb4;
-- Ejecutado por root
CREATE TABLESPACE ts_catalogos
  ADD DATAFILE 'C:/tablespaces/mysql2/catalogos/ts_catalogos.ibd';
CREATE TABLESPACE ts_operacion
  ADD DATAFILE 'C:/tablespaces/mysql2/operacion/ts_operacion.ibd';
