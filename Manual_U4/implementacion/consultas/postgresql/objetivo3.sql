-- ==========================================================================
-- postgresql · Objetivo 3
-- Ejecuta:  dmejia (o cualquier rol de operación)
-- Conexión: base inversiones, cualquier instancia
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
WITH parametros AS (
  SELECT 'MEAP850304BV0'   AS cliente_rfc,
         DATE '2026-10-28' AS fecha_corte
),
exigible AS (
  -- Interés de los periodos que ya terminaron a la fecha de corte
  SELECT t.inversion_num, SUM(t.interes_monto) AS interes_exigible
  FROM parametros p
    JOIN cliente c ON c.cliente_rfc = p.cliente_rfc
    JOIN inversion i ON i.cliente_num = c.cliente_num
    JOIN interes t ON t.inversion_num = i.inversion_num
  WHERE t.interes_fecha_final <= p.fecha_corte
  GROUP BY t.inversion_num
),
pagado AS (
  SELECT g.inversion_num, SUM(g.pago_interes) AS interes_pagado,
         SUM(g.pago_mora) AS mora_pagada
  FROM parametros p
    JOIN cliente c ON c.cliente_rfc = p.cliente_rfc
    JOIN inversion i ON i.cliente_num = c.cliente_num
    JOIN pago g ON g.inversion_num = i.inversion_num
  WHERE g.pago_fecha <= p.fecha_corte
  GROUP BY g.inversion_num
)
SELECT i.inversion_num, i.pagare_num,
       i.pagare_fecha AS suscripcion,
       i.inversion_fecha_vencimiento AS vencimiento,
       i.inversion_capital AS capital,
       CASE WHEN l.inversion_num IS NOT NULL THEN 'Liquidada'
            WHEN i.inversion_fecha_vencimiento < p.fecha_corte THEN 'Vencida'
            ELSE 'Vigente'
       END AS estado,
       COALESCE(e.interes_exigible, 0.00) AS interes_exigible,
       COALESCE(g.interes_pagado, 0.00) AS interes_pagado,
       COALESCE(e.interes_exigible, 0.00) - COALESCE(g.interes_pagado, 0.00)
         AS interes_pendiente,
       COALESCE(g.mora_pagada, 0.00) + COALESCE(l.liquidacion_mora, 0.00)
         AS mora_pagada,
       COALESCE(l.liquidacion_capital, 0.00) AS capital_devuelto
FROM parametros p
  JOIN cliente c ON c.cliente_rfc = p.cliente_rfc
  JOIN inversion i ON i.cliente_num = c.cliente_num
  LEFT JOIN exigible e ON e.inversion_num = i.inversion_num
  LEFT JOIN pagado g ON g.inversion_num = i.inversion_num
  LEFT JOIN liquidacion l
    ON l.inversion_num = i.inversion_num
   AND l.liquidacion_fecha <= p.fecha_corte
WHERE i.pagare_fecha <= p.fecha_corte
ORDER BY i.pagare_fecha;
