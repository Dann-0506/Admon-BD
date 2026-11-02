-- ==========================================================================
-- MySQL · Procedimientos y triggers de validación
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Implementación física > MySQL > Objetos programados
-- ==========================================================================

SET NAMES utf8mb4;
DELIMITER //

CREATE DEFINER = CURRENT_USER PROCEDURE generar_tabla_interes(
  IN p_inversion_num INT)
SQL SECURITY DEFINER
MODIFIES SQL DATA
BEGIN
  DECLARE v_capital     DECIMAL(14,2);
  DECLARE v_tasa        DECIMAL(6,4);
  DECLARE v_dia         SMALLINT;
  DECLARE v_suscripcion DATE;
  DECLARE v_vencimiento DATE;
  DECLARE v_monto       DECIMAL(14,2);
  DECLARE v_inicio      DATE;
  DECLARE v_fin         DATE;

  SELECT inversion_capital, inversion_tasa, inversion_dia_pago,
         pagare_fecha, inversion_fecha_vencimiento
    INTO v_capital, v_tasa, v_dia, v_suscripcion, v_vencimiento
  FROM inversion
  WHERE inversion_num = p_inversion_num;

  IF v_capital IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La inversión no existe';
  END IF;

  IF EXISTS (SELECT 1 FROM interes
             WHERE inversion_num = p_inversion_num) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La inversión ya tiene tabla de interés';
  END IF;

  SET v_monto  = ROUND(v_capital * v_tasa / 100, 2);
  SET v_inicio = v_suscripcion;
  -- Primer día del mes siguiente, más los días hasta el día de pago
  SET v_fin = DATE_ADD(
                DATE_ADD(DATE_SUB(v_suscripcion,
                                  INTERVAL DAY(v_suscripcion) - 1 DAY),
                         INTERVAL 1 MONTH),
                INTERVAL v_dia - 1 DAY);

  IF v_fin > v_vencimiento THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El vencimiento es anterior al primer día de pago';
  END IF;

  WHILE v_fin <= v_vencimiento DO
    INSERT INTO interes (inversion_num, interes_fecha_inicial,
                         interes_fecha_final, interes_monto)
    VALUES (p_inversion_num, v_inicio, v_fin, v_monto);
    SET v_inicio = v_fin;
    SET v_fin    = DATE_ADD(v_fin, INTERVAL 1 MONTH);
  END WHILE;
END //

DELIMITER ;

DELIMITER //

CREATE DEFINER = CURRENT_USER PROCEDURE validar_aval(
  IN p_cliente_num INT, IN p_aval_num INT)
READS SQL DATA
BEGIN
  IF p_aval_num IS NOT NULL AND
     (SELECT aval_rfc FROM aval WHERE aval_num = p_aval_num) =
     (SELECT cliente_rfc FROM cliente WHERE cliente_num = p_cliente_num)
  THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El aval no puede ser el cliente de la inversión';
  END IF;
END //

CREATE DEFINER = CURRENT_USER PROCEDURE validar_liquidacion(
  IN p_inversion_num INT, IN p_fecha DATE, IN p_capital DECIMAL(14,2))
READS SQL DATA
BEGIN
  DECLARE v_capital     DECIMAL(14,2);
  DECLARE v_vencimiento DATE;

  SELECT inversion_capital, inversion_fecha_vencimiento
    INTO v_capital, v_vencimiento
  FROM inversion
  WHERE inversion_num = p_inversion_num;

  IF p_capital <> v_capital THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El capital liquidado debe ser igual al invertido';
  END IF;

  IF p_fecha < v_vencimiento THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La liquidación no puede ser anterior al vencimiento';
  END IF;
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_inversion_aval_ins
  BEFORE INSERT ON inversion FOR EACH ROW
BEGIN
  CALL validar_aval(NEW.cliente_num, NEW.aval_num);
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_inversion_aval_upd
  BEFORE UPDATE ON inversion FOR EACH ROW
BEGIN
  CALL validar_aval(NEW.cliente_num, NEW.aval_num);
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_liquidacion_validar_ins
  BEFORE INSERT ON liquidacion FOR EACH ROW
BEGIN
  CALL validar_liquidacion(NEW.inversion_num, NEW.liquidacion_fecha,
                           NEW.liquidacion_capital);
END //

CREATE DEFINER = CURRENT_USER TRIGGER trg_liquidacion_validar_upd
  BEFORE UPDATE ON liquidacion FOR EACH ROW
BEGIN
  CALL validar_liquidacion(NEW.inversion_num, NEW.liquidacion_fecha,
                           NEW.liquidacion_capital);
END //

DELIMITER ;
