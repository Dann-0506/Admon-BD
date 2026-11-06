-- ==========================================================================
-- mysql · Objetivo 5 · primera instancia
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: base inversiones, primera instancia (sin segmentación)
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET NAMES utf8mb4;
SELECT i.inversion_num, i.pagare_num, i.pagare_fecha AS suscripcion,
       s.sucursal_nombre,
       CONCAT(c.cliente_nombre, ' ', c.cliente_apellido) AS cliente,
       i.inversion_capital AS capital, i.inversion_tasa AS tasa,
       (SELECT COUNT(*) FROM interes t
        WHERE t.inversion_num = i.inversion_num) AS plazo_meses,
       i.inversion_fecha_vencimiento AS vencimiento,
       CASE WHEN l.inversion_num IS NOT NULL THEN 'Liquidada'
            WHEN i.inversion_fecha_vencimiento < CURRENT_DATE THEN 'Vencida'
            ELSE 'Vigente'
       END AS estado
FROM inversion i
  JOIN sucursal s ON s.sucursal_num = i.sucursal_num
  JOIN cliente c  ON c.cliente_num = i.cliente_num
  LEFT JOIN liquidacion l ON l.inversion_num = i.inversion_num
WHERE i.pagare_fecha BETWEEN '2026-01-01' AND '2026-10-28'
ORDER BY i.pagare_fecha;
