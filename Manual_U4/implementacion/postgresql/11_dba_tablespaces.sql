-- ==========================================================================
-- PostgreSQL · Asignación de tablas a tablespaces (primera instancia)
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Tablespaces > PostgreSQL > Asignación de las tablas
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Ejecutado por dlandero en la base de datos inversiones
SET ROLE rol_admin_bd;

-- Catálogos
ALTER TABLE empresa  SET TABLESPACE ts_catalogos;
ALTER TABLE sucursal SET TABLESPACE ts_catalogos;
ALTER TABLE cliente  SET TABLESPACE ts_catalogos;
ALTER TABLE aval     SET TABLESPACE ts_catalogos;
ALTER INDEX pk_empresa     SET TABLESPACE ts_catalogos;
ALTER INDEX pk_sucursal    SET TABLESPACE ts_catalogos;
ALTER INDEX pk_cliente     SET TABLESPACE ts_catalogos;
ALTER INDEX ak_cliente_rfc SET TABLESPACE ts_catalogos;
ALTER INDEX pk_aval        SET TABLESPACE ts_catalogos;
ALTER INDEX ak_aval_rfc    SET TABLESPACE ts_catalogos;

-- Operación
ALTER TABLE inversion   SET TABLESPACE ts_operacion;
ALTER TABLE interes     SET TABLESPACE ts_operacion;
ALTER TABLE pago        SET TABLESPACE ts_operacion;
ALTER TABLE liquidacion SET TABLESPACE ts_operacion;
ALTER INDEX pk_inversion        SET TABLESPACE ts_operacion;
ALTER INDEX ak_inversion_pagare SET TABLESPACE ts_operacion;
ALTER INDEX pk_interes          SET TABLESPACE ts_operacion;
ALTER INDEX pk_pago             SET TABLESPACE ts_operacion;
ALTER INDEX pk_liquidacion      SET TABLESPACE ts_operacion;

-- Bitácora
ALTER TABLE bitacora    SET TABLESPACE ts_bitacora;
ALTER INDEX pk_bitacora SET TABLESPACE ts_bitacora;
