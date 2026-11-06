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
SELECT bitacora_num, bitacora_fecha, bitacora_rol, bitacora_usuario,
       bitacora_tabla, bitacora_operacion, bitacora_ip, bitacora_sesion
FROM bitacora;

CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW bitacora_detalle AS
SELECT bitacora_num, bitacora_fecha, bitacora_query,
       bitacora_dato_anterior, bitacora_dato_nuevo
FROM bitacora;

-- Segmentación derivada para los objetivos: el cálculo se hace una sola vez
-- por periodo de interés y, a partir de él, por inversión
CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW interes_saldo AS
SELECT t.inversion_num, t.interes_num,
       t.interes_fecha_inicial, t.interes_fecha_final, t.interes_monto,
       COALESCE(SUM(g.pago_interes), 0) AS pagado,
       COALESCE(SUM(g.pago_mora), 0)    AS mora_pagada,
       t.interes_monto - COALESCE(SUM(g.pago_interes), 0) AS saldo,
       CASE WHEN t.interes_fecha_final < CURRENT_DATE
                 AND t.interes_monto > COALESCE(SUM(g.pago_interes), 0)
            THEN DATEDIFF(CURRENT_DATE, t.interes_fecha_final)
            ELSE 0
       END AS dias_atraso
FROM interes t
  LEFT JOIN pago g
    ON g.inversion_num = t.inversion_num
   AND g.interes_num = t.interes_num
GROUP BY t.inversion_num, t.interes_num, t.interes_fecha_inicial,
         t.interes_fecha_final, t.interes_monto;

-- El estado de cada inversión lo da el fragmento al que pertenece
CREATE DEFINER = CURRENT_USER SQL SECURITY DEFINER VIEW inversion_estado AS
SELECT i.inversion_num, i.pagare_num,
       c.cliente_num, c.cliente_rfc,
       CONCAT(c.cliente_nombre, ' ', c.cliente_apellido) AS cliente,
       s.sucursal_nombre,
       i.pagare_fecha AS suscripcion,
       i.inversion_fecha_vencimiento AS vencimiento,
       i.inversion_capital AS capital,
       i.inversion_tasa AS tasa,
       COUNT(*) AS plazo_meses,
       e.estado,
       CASE WHEN e.estado = 'Liquidada' THEN 0
            ELSE GREATEST(DATEDIFF(CURRENT_DATE,
                                   i.inversion_fecha_vencimiento), 0)
       END AS dias_vencida,
       SUM(CASE WHEN v.interes_fecha_final <= CURRENT_DATE
                THEN v.interes_monto ELSE 0 END) AS interes_exigible,
       SUM(v.pagado) AS interes_pagado,
       SUM(CASE WHEN v.interes_fecha_final <= CURRENT_DATE
                THEN v.interes_monto ELSE 0 END) - SUM(v.pagado)
         AS interes_pendiente,
       SUM(CASE WHEN v.dias_atraso > 0 THEN 1 ELSE 0 END)
         AS periodos_sin_pagar,
       SUM(CASE WHEN v.dias_atraso > 0 THEN v.saldo ELSE 0 END)
         AS interes_vencido,
       SUM(v.mora_pagada) + COALESCE(l.liquidacion_mora, 0) AS mora_pagada,
       COALESCE(l.liquidacion_capital, 0.00) AS capital_devuelto,
       CASE WHEN e.estado = 'Liquidada' THEN 0.00
            ELSE ROUND(i.inversion_capital * i.inversion_tasa_moratoria / 100
                       * GREATEST(DATEDIFF(CURRENT_DATE,
                                   i.inversion_fecha_vencimiento), 0) / 30
                       + SUM(v.saldo * i.inversion_tasa_moratoria / 100
                             * v.dias_atraso / 30), 2)
       END AS mora_estimada
FROM (SELECT inversion_num, 'Vigente' AS estado FROM inversion_vigente
      UNION ALL
      SELECT inversion_num, 'Vencida' FROM inversion_vencida
      UNION ALL
      SELECT inversion_num, 'Liquidada' FROM inversion_liquidada) e
  JOIN inversion i ON i.inversion_num = e.inversion_num
  JOIN cliente c   ON c.cliente_num = i.cliente_num
  JOIN sucursal s  ON s.sucursal_num = i.sucursal_num
  JOIN interes_saldo v ON v.inversion_num = i.inversion_num
  LEFT JOIN liquidacion l ON l.inversion_num = i.inversion_num
GROUP BY i.inversion_num, c.cliente_num, s.sucursal_num, l.inversion_num,
         e.estado;

-- Privilegios
GRANT SELECT ON inversiones.inversion_vigente
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
GRANT SELECT ON inversiones.inversion_vencida
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
GRANT SELECT ON inversiones.inversion_liquidada
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
GRANT SELECT ON inversiones.interes_saldo
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
GRANT SELECT ON inversiones.inversion_estado
  TO rol_gerente, rol_ejecutivo, rol_tesoreria;
