-- ==========================================================================
-- postgresql · Objetivo 4
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: base inversiones, primera o segunda instancia
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
\x on
SELECT i.inversion_num, i.pagare_num, i.pagare_fecha,
       s.sucursal_ciudad AS lugar_suscripcion,
       c.cliente_nombre, c.cliente_apellido,
       a.aval_nombre, a.aval_apellido,
       i.inversion_capital, i.inversion_moneda, i.inversion_tasa,
       i.inversion_tasa_moratoria, i.inversion_dia_pago,
       i.inversion_fecha_vencimiento, i.pagare_jurisdiccion
FROM inversion i
  JOIN sucursal s ON s.sucursal_num = i.sucursal_num
  JOIN cliente c  ON c.cliente_num = i.cliente_num
  LEFT JOIN aval a ON a.aval_num = i.aval_num
WHERE i.pagare_num = '0018/2024';
\x off

SELECT t.interes_num AS periodo,
       t.interes_fecha_inicial AS inicio, t.interes_fecha_final AS fin,
       t.interes_monto AS interes,
       COUNT(g.pago_fecha) AS pagos,
       MAX(g.pago_fecha)   AS ultimo_pago,
       COALESCE(SUM(g.pago_interes), 0) AS pagado,
       t.interes_monto - COALESCE(SUM(g.pago_interes), 0) AS saldo
FROM inversion i
  JOIN interes t ON t.inversion_num = i.inversion_num
  LEFT JOIN pago g
    ON g.inversion_num = t.inversion_num
   AND g.interes_num = t.interes_num
WHERE i.pagare_num = '0018/2024'
  AND t.interes_fecha_final BETWEEN '2025-06-01' AND '2026-03-31'
GROUP BY t.inversion_num, t.interes_num, t.interes_fecha_inicial,
         t.interes_fecha_final, t.interes_monto
ORDER BY t.interes_num;
