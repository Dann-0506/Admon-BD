-- ==========================================================================
-- postgresql · Objetivo 5
-- Ejecuta:  dmejia (o cualquier rol de operación)
-- Conexión: base inversiones, cualquier instancia
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
WITH parametros AS (
  SELECT DATE '2026-01-01' AS fecha_inicial,
         DATE '2026-10-28' AS fecha_final,
         DATE '2026-10-28' AS fecha_corte
)
SELECT i.inversion_num, i.pagare_num, i.pagare_fecha AS suscripcion,
       s.sucursal_nombre,
       CONCAT(c.cliente_nombre, ' ', c.cliente_apellido) AS cliente,
       i.inversion_capital AS capital, i.inversion_tasa AS tasa,
       (SELECT COUNT(*) FROM interes t
        WHERE t.inversion_num = i.inversion_num) AS plazo_meses,
       i.inversion_fecha_vencimiento AS vencimiento,
       CASE WHEN l.inversion_num IS NOT NULL THEN 'Liquidada'
            WHEN i.inversion_fecha_vencimiento < p.fecha_corte THEN 'Vencida'
            ELSE 'Vigente'
       END AS estado
FROM parametros p
  JOIN inversion i
    ON i.pagare_fecha BETWEEN p.fecha_inicial AND p.fecha_final
  JOIN sucursal s ON s.sucursal_num = i.sucursal_num
  JOIN cliente c ON c.cliente_num = i.cliente_num
  LEFT JOIN liquidacion l
    ON l.inversion_num = i.inversion_num
   AND l.liquidacion_fecha <= p.fecha_corte
ORDER BY i.pagare_fecha;
