-- ==========================================================================
-- MySQL, segunda instancia · Particionamiento
-- Ejecuta:  dlandero
-- Conexión: puerto 3308, base inversiones
-- Origen:   Particionamiento > MySQL
-- ==========================================================================

SET NAMES utf8mb4;
-- Ejecutado por dlandero en la segunda instancia, base de datos inversiones

-- 1. Las tablas particionadas no admiten llaves foráneas
ALTER TABLE pago DROP FOREIGN KEY fk_pago_interes;

-- 2. Particionamiento de las tablas existentes
ALTER TABLE pago
  PARTITION BY RANGE COLUMNS (pago_fecha) (
    PARTITION pago_2024      VALUES LESS THAN ('2025-01-01'),
    PARTITION pago_2025      VALUES LESS THAN ('2026-01-01'),
    PARTITION pago_2026      VALUES LESS THAN ('2027-01-01'),
    PARTITION pago_posterior VALUES LESS THAN (MAXVALUE)
  );

ALTER TABLE bitacora
  PARTITION BY RANGE COLUMNS (bitacora_fecha) (
    PARTITION bitacora_2026      VALUES LESS THAN ('2027-01-01'),
    PARTITION bitacora_2027      VALUES LESS THAN ('2028-01-01'),
    PARTITION bitacora_posterior VALUES LESS THAN (MAXVALUE)
  );

-- 3. La regla de la llave foránea, mediante triggers
DELIMITER //

CREATE DEFINER = CURRENT_USER PROCEDURE validar_pago_interes(
  IN p_inversion_num INT, IN p_interes_fecha_inicial DATE)
READS SQL DATA
BEGIN
  IF NOT EXISTS (SELECT 1 FROM interes
                 WHERE inversion_num = p_inversion_num
                   AND interes_fecha_inicial = p_interes_fecha_inicial) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El periodo de interés del pago no existe';
  END IF;
END //

CREATE DEFINER = CURRENT_USER PROCEDURE validar_interes_sin_pagos(
  IN p_inversion_num INT, IN p_interes_fecha_inicial DATE)
READS SQL DATA
BEGIN
  IF EXISTS (SELECT 1 FROM pago
             WHERE inversion_num = p_inversion_num
               AND interes_fecha_inicial = p_interes_fecha_inicial) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El periodo de interés tiene pagos registrados';
  END IF;
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_pago_interes_ins
  BEFORE INSERT ON pago FOR EACH ROW
BEGIN
  CALL validar_pago_interes(NEW.inversion_num, NEW.interes_fecha_inicial);
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_pago_interes_upd
  BEFORE UPDATE ON pago FOR EACH ROW
BEGIN
  CALL validar_pago_interes(NEW.inversion_num, NEW.interes_fecha_inicial);
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_interes_pago_del
  BEFORE DELETE ON interes FOR EACH ROW
BEGIN
  CALL validar_interes_sin_pagos(OLD.inversion_num, OLD.interes_fecha_inicial);
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_interes_pago_upd
  BEFORE UPDATE ON interes FOR EACH ROW
BEGIN
  IF NEW.inversion_num <> OLD.inversion_num
     OR NEW.interes_fecha_inicial <> OLD.interes_fecha_inicial THEN
    CALL validar_interes_sin_pagos(OLD.inversion_num,
                                   OLD.interes_fecha_inicial);
  END IF;
END //

DELIMITER ;
