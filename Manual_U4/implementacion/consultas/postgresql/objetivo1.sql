-- ==========================================================================
-- postgresql · Objetivo 1
-- Ejecuta:  dmejia (o cualquier rol de operación)
-- Conexión: base inversiones, cualquier instancia
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
WITH parametros AS (
  SELECT DATE '2025-01-01' AS fecha_inicial,
         DATE '2025-12-31' AS fecha_final,
         'jose'            AS nombre
)
SELECT c.cliente_num, c.cliente_rfc,
       CONCAT(c.cliente_nombre, ' ', c.cliente_apellido) AS cliente,
       c.cliente_direccion, c.cliente_telefono,
       COUNT(*) AS inversiones,
       SUM(i.inversion_capital) AS capital_total
FROM parametros p
  JOIN inversion i
    ON i.pagare_fecha BETWEEN p.fecha_inicial AND p.fecha_final
  JOIN cliente c ON c.cliente_num = i.cliente_num
WHERE translate(CONCAT(c.cliente_nombre, ' ', c.cliente_apellido),
                'ÁÉÍÓÚÜÑáéíóúüñ', 'AEIOUUNaeiouun')
      ILIKE translate(CONCAT('%', p.nombre, '%'),
                      'ÁÉÍÓÚÜÑáéíóúüñ', 'AEIOUUNaeiouun')
GROUP BY c.cliente_num
ORDER BY c.cliente_apellido, c.cliente_nombre;
