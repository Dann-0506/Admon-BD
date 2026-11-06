-- ==========================================================================
-- mysql · Objetivo 5 · segunda instancia
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: segunda instancia (con segmentación), base inversiones
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET NAMES utf8mb4;
SELECT inversion_num, pagare_num, suscripcion, sucursal_nombre, cliente,
       capital, tasa, plazo_meses, vencimiento, estado
FROM inversion_estado
WHERE suscripcion BETWEEN '2026-01-01' AND '2026-10-28'
ORDER BY suscripcion;
