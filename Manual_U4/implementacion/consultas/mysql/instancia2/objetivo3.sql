-- ==========================================================================
-- mysql · Objetivo 3 · segunda instancia
-- Ejecuta:  op_gerente (o cualquier cuenta de operación)
-- Conexión: segunda instancia (con segmentación), base inversiones
-- Origen:   Introducción > Consultas de los objetivos específicos
-- ==========================================================================

SET NAMES utf8mb4;
SELECT inversion_num, pagare_num, suscripcion, vencimiento, capital,
       estado, interes_exigible, interes_pagado, interes_pendiente,
       mora_pagada, capital_devuelto
FROM inversion_estado
WHERE cliente_rfc = 'MEAP850304BV0'
ORDER BY suscripcion;
