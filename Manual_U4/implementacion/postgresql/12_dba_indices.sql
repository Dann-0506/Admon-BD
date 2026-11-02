-- ==========================================================================
-- PostgreSQL · Índices (ambas instancias)
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Índices > PostgreSQL
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Ejecutado por dlandero en la base de datos inversiones de cada instancia
SET ROLE rol_admin_bd;

CREATE INDEX ix_inversion_cliente
  ON inversion (cliente_num) TABLESPACE ts_operacion;
CREATE INDEX ix_inversion_pagare_fecha
  ON inversion (pagare_fecha) TABLESPACE ts_operacion;
CREATE INDEX ix_inversion_vencimiento
  ON inversion (inversion_fecha_vencimiento) TABLESPACE ts_operacion;
CREATE INDEX ix_bitacora_fecha
  ON bitacora (bitacora_fecha) TABLESPACE ts_bitacora;
