-- ==========================================================================
-- PostgreSQL, segunda instancia · Segmentación
-- Ejecuta:  dlandero
-- Conexión: puerto 5434, base inversiones
-- Origen:   Segmentación > PostgreSQL
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Ejecutado por dlandero en la segunda instancia, base de datos inversiones
SET ROLE rol_admin_bd;

-- Fragmentación horizontal de inversion, por estado
CREATE VIEW inversion_vigente AS
SELECT i.*
FROM inversion i
WHERE i.inversion_fecha_vencimiento >= CURRENT_DATE
  AND NOT EXISTS (SELECT 1 FROM liquidacion l
                  WHERE l.inversion_num = i.inversion_num);

CREATE VIEW inversion_vencida AS
SELECT i.*
FROM inversion i
WHERE i.inversion_fecha_vencimiento < CURRENT_DATE
  AND NOT EXISTS (SELECT 1 FROM liquidacion l
                  WHERE l.inversion_num = i.inversion_num);

CREATE VIEW inversion_liquidada AS
SELECT i.*
FROM inversion i
WHERE EXISTS (SELECT 1 FROM liquidacion l
              WHERE l.inversion_num = i.inversion_num);

-- Fragmentación vertical de bitacora
CREATE VIEW bitacora_resumen AS
SELECT bitacora_num, bitacora_fecha, bitacora_usuario, bitacora_tabla,
       bitacora_operacion, bitacora_ip, bitacora_sesion
FROM bitacora;

CREATE VIEW bitacora_detalle AS
SELECT bitacora_num, bitacora_fecha, bitacora_query,
       bitacora_dato_anterior, bitacora_dato_nuevo
FROM bitacora;

-- Privilegios
GRANT SELECT ON inversion_vigente, inversion_vencida, inversion_liquidada
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
