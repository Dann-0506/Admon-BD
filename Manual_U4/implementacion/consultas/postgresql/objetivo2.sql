-- ==========================================================================
-- postgresql · Objetivo 2
-- Ejecuta:  dmejia (o cualquier rol de operación)
-- Conexión: base inversiones, cualquier instancia
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
WITH parametros AS (
  SELECT DATE '2025-01-01' AS fecha_inicial,
         DATE '2025-12-31' AS fecha_final,
         DATE '2026-10-28' AS fecha_corte
),
saldo AS (
  -- Saldo de interés de cada periodo vencido a la fecha de corte
  SELECT t.inversion_num, t.interes_fecha_final,
         t.interes_monto - COALESCE(SUM(g.pago_interes), 0) AS saldo
  FROM parametros p
    JOIN interes t ON t.interes_fecha_final < p.fecha_corte
    LEFT JOIN pago g
      ON g.inversion_num = t.inversion_num
     AND g.interes_fecha_inicial = t.interes_fecha_inicial
     AND g.pago_fecha <= p.fecha_corte
  GROUP BY t.inversion_num, t.interes_fecha_inicial,
           t.interes_fecha_final, t.interes_monto
)
SELECT i.inversion_num, i.pagare_num,
       CONCAT(c.cliente_nombre, ' ', c.cliente_apellido) AS cliente,
       s.sucursal_nombre,
       i.inversion_capital AS capital,
       i.inversion_fecha_vencimiento AS vencimiento,
       p.fecha_corte - i.inversion_fecha_vencimiento AS dias_vencida,
       SUM(CASE WHEN d.saldo > 0 THEN 1 ELSE 0 END) AS periodos_sin_pagar,
       SUM(d.saldo) AS interes_vencido,
       ROUND(i.inversion_capital * i.inversion_tasa_moratoria / 100
             * (p.fecha_corte - i.inversion_fecha_vencimiento) / 30
             + SUM(d.saldo * i.inversion_tasa_moratoria / 100
                   * (p.fecha_corte - d.interes_fecha_final) / 30), 2)
         AS mora_estimada
FROM parametros p
  JOIN inversion i
    ON i.inversion_fecha_vencimiento BETWEEN p.fecha_inicial AND p.fecha_final
   AND i.inversion_fecha_vencimiento < p.fecha_corte
  JOIN cliente c ON c.cliente_num = i.cliente_num
  JOIN sucursal s ON s.sucursal_num = i.sucursal_num
  JOIN saldo d ON d.inversion_num = i.inversion_num
WHERE NOT EXISTS (SELECT 1 FROM liquidacion l
                  WHERE l.inversion_num = i.inversion_num
                    AND l.liquidacion_fecha <= p.fecha_corte)
GROUP BY i.inversion_num, c.cliente_num, s.sucursal_num, p.fecha_corte
ORDER BY i.inversion_fecha_vencimiento;
