-- ==========================================================================
-- postgresql · Objetivo 1
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: base inversiones, primera o segunda instancia
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
SELECT c.cliente_num, c.cliente_rfc,
       c.cliente_nombre, c.cliente_apellido,
       c.cliente_direccion, c.cliente_telefono,
       COUNT(*)                 AS inversiones,
       SUM(i.inversion_capital) AS capital_total
FROM inversion i
  JOIN cliente c ON c.cliente_num = i.cliente_num
WHERE i.pagare_fecha BETWEEN '2025-01-01' AND '2025-12-31'
  AND translate(c.cliente_nombre || ' ' || c.cliente_apellido,
                'ÁÉÍÓÚÜÑáéíóúüñ', 'AEIOUUNaeiouun') ILIKE '%jose%'
GROUP BY c.cliente_num
ORDER BY c.cliente_apellido, c.cliente_nombre;
