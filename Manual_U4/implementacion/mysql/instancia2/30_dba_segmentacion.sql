-- ==========================================================================
-- MySQL, segunda instancia · Segmentación
-- Ejecuta:  dlandero
-- Conexión: puerto 3308, base inversiones
-- Origen:   Segmentación > MySQL
-- ==========================================================================

SET NAMES utf8mb4;
-- Ejecutado por dlandero en la segunda instancia, base de datos inversiones

-- Fragmentación horizontal de inversion, por estado
CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW inversion_vigente AS
SELECT i.*
FROM inversion i
WHERE i.inversion_fecha_vencimiento >= CURRENT_DATE
  AND NOT EXISTS (SELECT 1 FROM liquidacion l
                  WHERE l.inversion_num = i.inversion_num);

CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW inversion_vencida AS
SELECT i.*
FROM inversion i
WHERE i.inversion_fecha_vencimiento < CURRENT_DATE
  AND NOT EXISTS (SELECT 1 FROM liquidacion l
                  WHERE l.inversion_num = i.inversion_num);

CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW inversion_liquidada AS
SELECT i.*
FROM inversion i
WHERE EXISTS (SELECT 1 FROM liquidacion l
              WHERE l.inversion_num = i.inversion_num);

-- Fragmentación vertical de bitacora
CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW bitacora_resumen AS
SELECT bitacora_num, bitacora_fecha, bitacora_usuario, bitacora_tabla,
       bitacora_operacion, bitacora_ip, bitacora_sesion
FROM bitacora;

CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW bitacora_detalle AS
SELECT bitacora_num, bitacora_fecha, bitacora_query,
       bitacora_dato_anterior, bitacora_dato_nuevo
FROM bitacora;

-- Privilegios
GRANT SELECT ON inversiones.inversion_vigente
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
GRANT SELECT ON inversiones.inversion_vencida
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
GRANT SELECT ON inversiones.inversion_liquidada
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
