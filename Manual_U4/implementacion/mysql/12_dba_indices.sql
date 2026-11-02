-- ==========================================================================
-- MySQL · Índices (ambas instancias)
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Índices > MySQL
-- ==========================================================================

SET NAMES utf8mb4;
-- Ejecutado por dlandero en la base de datos inversiones de cada instancia
CREATE INDEX ix_inversion_cliente      ON inversion (cliente_num);
CREATE INDEX ix_inversion_pagare_fecha ON inversion (pagare_fecha);
CREATE INDEX ix_inversion_vencimiento  ON inversion (inversion_fecha_vencimiento);
CREATE INDEX ix_bitacora_fecha         ON bitacora (bitacora_fecha);
