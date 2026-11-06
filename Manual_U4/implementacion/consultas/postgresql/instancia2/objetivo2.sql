-- ==========================================================================
-- postgresql · Objetivo 2 · segunda instancia
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: segunda instancia (con segmentación), base inversiones
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET client_encoding = 'UTF8';
SELECT inversion_num, pagare_num, cliente, sucursal_nombre, capital,
       vencimiento, dias_vencida, periodos_sin_pagar,
       interes_vencido, mora_estimada
FROM inversion_estado
WHERE estado = 'Vencida'
  AND vencimiento BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY vencimiento;
