-- ==========================================================================
-- MySQL, segunda instancia · Asignación de tablas a tablespaces, sin pago ni bitacora
-- Ejecuta:  dlandero
-- Conexión: puerto 3308, base inversiones
-- Origen:   Tablespaces > MySQL; pago y bitacora permanecen en el directorio de datos
-- ==========================================================================

SET NAMES utf8mb4;
-- Ejecutado por dlandero en la base de datos inversiones
-- Catálogos
ALTER TABLE empresa  TABLESPACE ts_catalogos;
ALTER TABLE sucursal TABLESPACE ts_catalogos;
ALTER TABLE cliente  TABLESPACE ts_catalogos;
ALTER TABLE aval     TABLESPACE ts_catalogos;

-- Operación
ALTER TABLE inversion   TABLESPACE ts_operacion;
ALTER TABLE interes     TABLESPACE ts_operacion;
ALTER TABLE liquidacion TABLESPACE ts_operacion;
