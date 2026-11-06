-- ==========================================================================
-- mysql · Objetivo 2 · primera instancia
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: base inversiones, primera instancia (sin segmentación)
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET NAMES utf8mb4;
WITH periodo AS (
  -- Saldo de interés de cada periodo ya terminado
  SELECT t.inversion_num, t.interes_fecha_final,
         t.interes_monto - COALESCE(SUM(g.pago_interes), 0) AS saldo
  FROM interes t
    LEFT JOIN pago g
      ON g.inversion_num = t.inversion_num
     AND g.interes_num = t.interes_num
  WHERE t.interes_fecha_final < CURRENT_DATE
  GROUP BY t.inversion_num, t.interes_num,
           t.interes_fecha_final, t.interes_monto
)
SELECT i.inversion_num, i.pagare_num,
       CONCAT(c.cliente_nombre, ' ', c.cliente_apellido) AS cliente,
       s.sucursal_nombre,
       i.inversion_capital AS capital,
       i.inversion_fecha_vencimiento AS vencimiento,
       DATEDIFF(CURRENT_DATE, i.inversion_fecha_vencimiento) AS dias_vencida,
       SUM(CASE WHEN p.saldo > 0 THEN 1 ELSE 0 END) AS periodos_sin_pagar,
       SUM(CASE WHEN p.saldo > 0 THEN p.saldo ELSE 0 END) AS interes_vencido,
       ROUND(i.inversion_capital * i.inversion_tasa_moratoria / 100
             * DATEDIFF(CURRENT_DATE, i.inversion_fecha_vencimiento) / 30
             + SUM(CASE WHEN p.saldo > 0
                        THEN p.saldo * i.inversion_tasa_moratoria / 100
                             * DATEDIFF(CURRENT_DATE, p.interes_fecha_final) / 30
                        ELSE 0 END), 2) AS mora_estimada
FROM inversion i
  JOIN cliente c  ON c.cliente_num = i.cliente_num
  JOIN sucursal s ON s.sucursal_num = i.sucursal_num
  JOIN periodo p  ON p.inversion_num = i.inversion_num
WHERE i.inversion_fecha_vencimiento BETWEEN '2025-01-01' AND '2025-12-31'
  AND i.inversion_fecha_vencimiento < CURRENT_DATE
  AND NOT EXISTS (SELECT 1 FROM liquidacion l
                  WHERE l.inversion_num = i.inversion_num)
GROUP BY i.inversion_num, c.cliente_num, s.sucursal_num
ORDER BY i.inversion_fecha_vencimiento;
