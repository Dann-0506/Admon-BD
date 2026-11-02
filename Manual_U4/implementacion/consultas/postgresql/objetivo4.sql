-- ==========================================================================
-- postgresql · Objetivo 4
-- Ejecuta:  dmejia (o cualquier rol de operación)
-- Conexión: base inversiones, cualquier instancia
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
\x on
WITH parametros AS (
  SELECT '0018/2024' AS pagare_num
)
SELECT i.inversion_num, i.pagare_num, i.pagare_fecha,
       s.sucursal_ciudad AS lugar_suscripcion,
       CONCAT(c.cliente_nombre, ' ', c.cliente_apellido) AS inversionista,
       CASE WHEN a.aval_num IS NULL THEN 'Sin aval'
            ELSE CONCAT(a.aval_nombre, ' ', a.aval_apellido)
       END AS aval,
       i.inversion_capital AS capital, i.inversion_moneda AS moneda,
       i.inversion_tasa AS tasa_mensual,
       i.inversion_tasa_moratoria AS tasa_moratoria,
       i.inversion_dia_pago AS dia_pago,
       i.inversion_fecha_vencimiento AS vencimiento,
       i.pagare_jurisdiccion AS jurisdiccion
FROM parametros p
  JOIN inversion i ON i.pagare_num = p.pagare_num
  JOIN sucursal s ON s.sucursal_num = i.sucursal_num
  JOIN cliente c ON c.cliente_num = i.cliente_num
  LEFT JOIN aval a ON a.aval_num = i.aval_num;
\x off

WITH parametros AS (
  SELECT '0018/2024'       AS pagare_num,
         DATE '2025-06-01' AS fecha_inicial,
         DATE '2026-03-31' AS fecha_final,
         DATE '2026-10-28' AS fecha_corte
)
SELECT t.interes_fecha_inicial AS inicio, t.interes_fecha_final AS fin,
       t.interes_monto AS interes,
       COUNT(g.pago_fecha) AS pagos,
       MAX(g.pago_fecha) AS ultimo_pago,
       COALESCE(SUM(g.pago_interes), 0.00) AS pagado,
       COALESCE(SUM(g.pago_mora), 0.00) AS mora_pagada,
       t.interes_monto - COALESCE(SUM(g.pago_interes), 0.00) AS saldo,
       CASE WHEN COALESCE(SUM(g.pago_interes), 0) >= t.interes_monto THEN
              CASE WHEN MAX(g.pago_fecha) > t.interes_fecha_final
                   THEN 'Pagado con atraso' ELSE 'Pagado' END
            WHEN COALESCE(SUM(g.pago_interes), 0) > 0 THEN 'Pago parcial'
            WHEN t.interes_fecha_final < p.fecha_corte THEN 'Vencido'
            ELSE 'Por vencer'
       END AS estado
FROM parametros p
  JOIN inversion i ON i.pagare_num = p.pagare_num
  JOIN interes t
    ON t.inversion_num = i.inversion_num
   AND t.interes_fecha_final BETWEEN p.fecha_inicial AND p.fecha_final
  LEFT JOIN pago g
    ON g.inversion_num = t.inversion_num
   AND g.interes_fecha_inicial = t.interes_fecha_inicial
   AND g.pago_fecha <= p.fecha_corte
GROUP BY t.inversion_num, t.interes_fecha_inicial, t.interes_fecha_final,
         t.interes_monto, p.fecha_corte
ORDER BY t.interes_fecha_inicial;
