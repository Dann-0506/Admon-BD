-- ==========================================================================
-- mysql · Objetivo 3 · primera instancia
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: base inversiones, primera instancia (sin segmentación)
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET NAMES utf8mb4;
WITH periodo AS (
  -- Lo pagado de cada periodo de interés
  SELECT t.inversion_num, t.interes_fecha_final, t.interes_monto,
         COALESCE(SUM(g.pago_interes), 0) AS pagado,
         COALESCE(SUM(g.pago_mora), 0)    AS mora_pagada
  FROM interes t
    LEFT JOIN pago g
      ON g.inversion_num = t.inversion_num
     AND g.interes_num = t.interes_num
  GROUP BY t.inversion_num, t.interes_num,
           t.interes_fecha_final, t.interes_monto
)
SELECT i.inversion_num, i.pagare_num, i.pagare_fecha AS suscripcion,
       i.inversion_fecha_vencimiento AS vencimiento,
       i.inversion_capital AS capital,
       CASE WHEN l.inversion_num IS NOT NULL THEN 'Liquidada'
            WHEN i.inversion_fecha_vencimiento < CURRENT_DATE THEN 'Vencida'
            ELSE 'Vigente'
       END AS estado,
       SUM(CASE WHEN p.interes_fecha_final <= CURRENT_DATE
                THEN p.interes_monto ELSE 0 END) AS interes_exigible,
       SUM(p.pagado) AS interes_pagado,
       SUM(CASE WHEN p.interes_fecha_final <= CURRENT_DATE
                THEN p.interes_monto ELSE 0 END) - SUM(p.pagado)
         AS interes_pendiente,
       SUM(p.mora_pagada) + COALESCE(l.liquidacion_mora, 0) AS mora_pagada,
       COALESCE(l.liquidacion_capital, 0.00) AS capital_devuelto
FROM cliente c
  JOIN inversion i ON i.cliente_num = c.cliente_num
  JOIN periodo p   ON p.inversion_num = i.inversion_num
  LEFT JOIN liquidacion l ON l.inversion_num = i.inversion_num
WHERE c.cliente_rfc = 'MEAP850304BV0'
GROUP BY i.inversion_num, l.inversion_num
ORDER BY i.pagare_fecha;
