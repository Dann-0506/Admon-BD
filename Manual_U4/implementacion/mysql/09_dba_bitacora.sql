-- ==========================================================================
-- MySQL · Bitácora
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Bitácora > MySQL
-- ==========================================================================

SET NAMES utf8mb4;
-- Ejecutado por dlandero en la base de datos inversiones
DELIMITER //

CREATE DEFINER = CURRENT_USER PROCEDURE registrar_bitacora(
  IN p_tabla     VARCHAR(63),
  IN p_operacion VARCHAR(6),
  IN p_anterior  JSON,
  IN p_nuevo     JSON)
SQL SECURITY DEFINER
MODIFIES SQL DATA
BEGIN
  DECLARE v_cuenta  VARCHAR(100);
  DECLARE v_rol     VARCHAR(63);
  DECLARE v_usuario VARCHAR(100);

  SET v_cuenta = SUBSTRING_INDEX(USER(), '@', 1);

  -- Rol del sistema al que pertenece la cuenta que inició la sesión
  SET v_rol = COALESCE(
    (SELECT FROM_USER FROM mysql.role_edges
     WHERE TO_USER = v_cuenta AND FROM_USER LIKE 'rol\\_%'
     LIMIT 1),
    'sin_rol');

  IF v_rol IN ('rol_gerente', 'rol_ejecutivo', 'rol_tesoreria') THEN
    -- Cuenta compartida: la persona se identifica con SET @usuario
    SET v_usuario = NULLIF(TRIM(@usuario), '');
    IF v_usuario IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Falta SET @usuario al inicio de la transacción';
    END IF;
  ELSE
    -- Cuenta administrativa: la cuenta identifica a la persona
    SET v_usuario = v_cuenta;
  END IF;

  INSERT INTO bitacora (bitacora_fecha, bitacora_rol, bitacora_usuario,
                        bitacora_tabla, bitacora_operacion, bitacora_ip,
                        bitacora_sesion, bitacora_query,
                        bitacora_dato_anterior, bitacora_dato_nuevo)
  VALUES (NOW(), v_rol, v_usuario, p_tabla, p_operacion,
          SUBSTRING_INDEX(USER(), '@', -1), CONNECTION_ID(),
          (SELECT PROCESSLIST_INFO
           FROM performance_schema.threads
           WHERE PROCESSLIST_ID = CONNECTION_ID()),
          p_anterior, p_nuevo);
END //

DELIMITER ;

-- empresa
CREATE TRIGGER trg_empresa_bitacora_ins AFTER INSERT ON empresa
FOR EACH ROW CALL registrar_bitacora('empresa', 'INSERT',
  NULL,
  JSON_OBJECT('empresa_rfc', NEW.empresa_rfc,
              'empresa_nombre', NEW.empresa_nombre,
              'empresa_direccion', NEW.empresa_direccion));

CREATE TRIGGER trg_empresa_bitacora_upd AFTER UPDATE ON empresa
FOR EACH ROW CALL registrar_bitacora('empresa', 'UPDATE',
  JSON_OBJECT('empresa_rfc', OLD.empresa_rfc,
              'empresa_nombre', OLD.empresa_nombre,
              'empresa_direccion', OLD.empresa_direccion),
  JSON_OBJECT('empresa_rfc', NEW.empresa_rfc,
              'empresa_nombre', NEW.empresa_nombre,
              'empresa_direccion', NEW.empresa_direccion));

CREATE TRIGGER trg_empresa_bitacora_del AFTER DELETE ON empresa
FOR EACH ROW CALL registrar_bitacora('empresa', 'DELETE',
  JSON_OBJECT('empresa_rfc', OLD.empresa_rfc,
              'empresa_nombre', OLD.empresa_nombre,
              'empresa_direccion', OLD.empresa_direccion),
  NULL);

-- sucursal
CREATE TRIGGER trg_sucursal_bitacora_ins AFTER INSERT ON sucursal
FOR EACH ROW CALL registrar_bitacora('sucursal', 'INSERT',
  NULL,
  JSON_OBJECT('sucursal_num', NEW.sucursal_num,
              'empresa_rfc', NEW.empresa_rfc,
              'sucursal_nombre', NEW.sucursal_nombre,
              'sucursal_ciudad', NEW.sucursal_ciudad,
              'sucursal_direccion', NEW.sucursal_direccion));

CREATE TRIGGER trg_sucursal_bitacora_upd AFTER UPDATE ON sucursal
FOR EACH ROW CALL registrar_bitacora('sucursal', 'UPDATE',
  JSON_OBJECT('sucursal_num', OLD.sucursal_num,
              'empresa_rfc', OLD.empresa_rfc,
              'sucursal_nombre', OLD.sucursal_nombre,
              'sucursal_ciudad', OLD.sucursal_ciudad,
              'sucursal_direccion', OLD.sucursal_direccion),
  JSON_OBJECT('sucursal_num', NEW.sucursal_num,
              'empresa_rfc', NEW.empresa_rfc,
              'sucursal_nombre', NEW.sucursal_nombre,
              'sucursal_ciudad', NEW.sucursal_ciudad,
              'sucursal_direccion', NEW.sucursal_direccion));

CREATE TRIGGER trg_sucursal_bitacora_del AFTER DELETE ON sucursal
FOR EACH ROW CALL registrar_bitacora('sucursal', 'DELETE',
  JSON_OBJECT('sucursal_num', OLD.sucursal_num,
              'empresa_rfc', OLD.empresa_rfc,
              'sucursal_nombre', OLD.sucursal_nombre,
              'sucursal_ciudad', OLD.sucursal_ciudad,
              'sucursal_direccion', OLD.sucursal_direccion),
  NULL);

-- cliente
CREATE TRIGGER trg_cliente_bitacora_ins AFTER INSERT ON cliente
FOR EACH ROW CALL registrar_bitacora('cliente', 'INSERT',
  NULL,
  JSON_OBJECT('cliente_num', NEW.cliente_num,
              'cliente_rfc', NEW.cliente_rfc,
              'cliente_nombre', NEW.cliente_nombre,
              'cliente_apellido', NEW.cliente_apellido,
              'cliente_direccion', NEW.cliente_direccion,
              'cliente_telefono', NEW.cliente_telefono));

CREATE TRIGGER trg_cliente_bitacora_upd AFTER UPDATE ON cliente
FOR EACH ROW CALL registrar_bitacora('cliente', 'UPDATE',
  JSON_OBJECT('cliente_num', OLD.cliente_num,
              'cliente_rfc', OLD.cliente_rfc,
              'cliente_nombre', OLD.cliente_nombre,
              'cliente_apellido', OLD.cliente_apellido,
              'cliente_direccion', OLD.cliente_direccion,
              'cliente_telefono', OLD.cliente_telefono),
  JSON_OBJECT('cliente_num', NEW.cliente_num,
              'cliente_rfc', NEW.cliente_rfc,
              'cliente_nombre', NEW.cliente_nombre,
              'cliente_apellido', NEW.cliente_apellido,
              'cliente_direccion', NEW.cliente_direccion,
              'cliente_telefono', NEW.cliente_telefono));

CREATE TRIGGER trg_cliente_bitacora_del AFTER DELETE ON cliente
FOR EACH ROW CALL registrar_bitacora('cliente', 'DELETE',
  JSON_OBJECT('cliente_num', OLD.cliente_num,
              'cliente_rfc', OLD.cliente_rfc,
              'cliente_nombre', OLD.cliente_nombre,
              'cliente_apellido', OLD.cliente_apellido,
              'cliente_direccion', OLD.cliente_direccion,
              'cliente_telefono', OLD.cliente_telefono),
  NULL);

-- aval
CREATE TRIGGER trg_aval_bitacora_ins AFTER INSERT ON aval
FOR EACH ROW CALL registrar_bitacora('aval', 'INSERT',
  NULL,
  JSON_OBJECT('aval_num', NEW.aval_num,
              'aval_rfc', NEW.aval_rfc,
              'aval_nombre', NEW.aval_nombre,
              'aval_apellido', NEW.aval_apellido,
              'aval_direccion', NEW.aval_direccion));

CREATE TRIGGER trg_aval_bitacora_upd AFTER UPDATE ON aval
FOR EACH ROW CALL registrar_bitacora('aval', 'UPDATE',
  JSON_OBJECT('aval_num', OLD.aval_num,
              'aval_rfc', OLD.aval_rfc,
              'aval_nombre', OLD.aval_nombre,
              'aval_apellido', OLD.aval_apellido,
              'aval_direccion', OLD.aval_direccion),
  JSON_OBJECT('aval_num', NEW.aval_num,
              'aval_rfc', NEW.aval_rfc,
              'aval_nombre', NEW.aval_nombre,
              'aval_apellido', NEW.aval_apellido,
              'aval_direccion', NEW.aval_direccion));

CREATE TRIGGER trg_aval_bitacora_del AFTER DELETE ON aval
FOR EACH ROW CALL registrar_bitacora('aval', 'DELETE',
  JSON_OBJECT('aval_num', OLD.aval_num,
              'aval_rfc', OLD.aval_rfc,
              'aval_nombre', OLD.aval_nombre,
              'aval_apellido', OLD.aval_apellido,
              'aval_direccion', OLD.aval_direccion),
  NULL);

-- inversion
CREATE TRIGGER trg_inversion_bitacora_ins AFTER INSERT ON inversion
FOR EACH ROW CALL registrar_bitacora('inversion', 'INSERT',
  NULL,
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'pagare_num', NEW.pagare_num,
              'sucursal_num', NEW.sucursal_num,
              'cliente_num', NEW.cliente_num,
              'aval_num', NEW.aval_num,
              'inversion_capital', NEW.inversion_capital,
              'inversion_tasa', NEW.inversion_tasa,
              'inversion_tasa_moratoria', NEW.inversion_tasa_moratoria,
              'inversion_dia_pago', NEW.inversion_dia_pago,
              'pagare_fecha', NEW.pagare_fecha,
              'inversion_moneda', NEW.inversion_moneda,
              'pagare_jurisdiccion', NEW.pagare_jurisdiccion,
              'inversion_fecha_vencimiento', NEW.inversion_fecha_vencimiento));

CREATE TRIGGER trg_inversion_bitacora_upd AFTER UPDATE ON inversion
FOR EACH ROW CALL registrar_bitacora('inversion', 'UPDATE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'pagare_num', OLD.pagare_num,
              'sucursal_num', OLD.sucursal_num,
              'cliente_num', OLD.cliente_num,
              'aval_num', OLD.aval_num,
              'inversion_capital', OLD.inversion_capital,
              'inversion_tasa', OLD.inversion_tasa,
              'inversion_tasa_moratoria', OLD.inversion_tasa_moratoria,
              'inversion_dia_pago', OLD.inversion_dia_pago,
              'pagare_fecha', OLD.pagare_fecha,
              'inversion_moneda', OLD.inversion_moneda,
              'pagare_jurisdiccion', OLD.pagare_jurisdiccion,
              'inversion_fecha_vencimiento', OLD.inversion_fecha_vencimiento),
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'pagare_num', NEW.pagare_num,
              'sucursal_num', NEW.sucursal_num,
              'cliente_num', NEW.cliente_num,
              'aval_num', NEW.aval_num,
              'inversion_capital', NEW.inversion_capital,
              'inversion_tasa', NEW.inversion_tasa,
              'inversion_tasa_moratoria', NEW.inversion_tasa_moratoria,
              'inversion_dia_pago', NEW.inversion_dia_pago,
              'pagare_fecha', NEW.pagare_fecha,
              'inversion_moneda', NEW.inversion_moneda,
              'pagare_jurisdiccion', NEW.pagare_jurisdiccion,
              'inversion_fecha_vencimiento', NEW.inversion_fecha_vencimiento));

CREATE TRIGGER trg_inversion_bitacora_del AFTER DELETE ON inversion
FOR EACH ROW CALL registrar_bitacora('inversion', 'DELETE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'pagare_num', OLD.pagare_num,
              'sucursal_num', OLD.sucursal_num,
              'cliente_num', OLD.cliente_num,
              'aval_num', OLD.aval_num,
              'inversion_capital', OLD.inversion_capital,
              'inversion_tasa', OLD.inversion_tasa,
              'inversion_tasa_moratoria', OLD.inversion_tasa_moratoria,
              'inversion_dia_pago', OLD.inversion_dia_pago,
              'pagare_fecha', OLD.pagare_fecha,
              'inversion_moneda', OLD.inversion_moneda,
              'pagare_jurisdiccion', OLD.pagare_jurisdiccion,
              'inversion_fecha_vencimiento', OLD.inversion_fecha_vencimiento),
  NULL);

-- interes
CREATE TRIGGER trg_interes_bitacora_ins AFTER INSERT ON interes
FOR EACH ROW CALL registrar_bitacora('interes', 'INSERT',
  NULL,
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'interes_num', NEW.interes_num,
              'interes_fecha_inicial', NEW.interes_fecha_inicial,
              'interes_fecha_final', NEW.interes_fecha_final,
              'interes_monto', NEW.interes_monto));

CREATE TRIGGER trg_interes_bitacora_upd AFTER UPDATE ON interes
FOR EACH ROW CALL registrar_bitacora('interes', 'UPDATE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'interes_num', OLD.interes_num,
              'interes_fecha_inicial', OLD.interes_fecha_inicial,
              'interes_fecha_final', OLD.interes_fecha_final,
              'interes_monto', OLD.interes_monto),
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'interes_num', NEW.interes_num,
              'interes_fecha_inicial', NEW.interes_fecha_inicial,
              'interes_fecha_final', NEW.interes_fecha_final,
              'interes_monto', NEW.interes_monto));

CREATE TRIGGER trg_interes_bitacora_del AFTER DELETE ON interes
FOR EACH ROW CALL registrar_bitacora('interes', 'DELETE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'interes_num', OLD.interes_num,
              'interes_fecha_inicial', OLD.interes_fecha_inicial,
              'interes_fecha_final', OLD.interes_fecha_final,
              'interes_monto', OLD.interes_monto),
  NULL);

-- pago
CREATE TRIGGER trg_pago_bitacora_ins AFTER INSERT ON pago
FOR EACH ROW CALL registrar_bitacora('pago', 'INSERT',
  NULL,
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'interes_num', NEW.interes_num,
              'pago_fecha', NEW.pago_fecha,
              'pago_interes', NEW.pago_interes,
              'pago_mora', NEW.pago_mora));

CREATE TRIGGER trg_pago_bitacora_upd AFTER UPDATE ON pago
FOR EACH ROW CALL registrar_bitacora('pago', 'UPDATE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'interes_num', OLD.interes_num,
              'pago_fecha', OLD.pago_fecha,
              'pago_interes', OLD.pago_interes,
              'pago_mora', OLD.pago_mora),
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'interes_num', NEW.interes_num,
              'pago_fecha', NEW.pago_fecha,
              'pago_interes', NEW.pago_interes,
              'pago_mora', NEW.pago_mora));

CREATE TRIGGER trg_pago_bitacora_del AFTER DELETE ON pago
FOR EACH ROW CALL registrar_bitacora('pago', 'DELETE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'interes_num', OLD.interes_num,
              'pago_fecha', OLD.pago_fecha,
              'pago_interes', OLD.pago_interes,
              'pago_mora', OLD.pago_mora),
  NULL);

-- liquidacion
CREATE TRIGGER trg_liquidacion_bitacora_ins AFTER INSERT ON liquidacion
FOR EACH ROW CALL registrar_bitacora('liquidacion', 'INSERT',
  NULL,
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'liquidacion_fecha', NEW.liquidacion_fecha,
              'liquidacion_capital', NEW.liquidacion_capital,
              'liquidacion_mora', NEW.liquidacion_mora));

CREATE TRIGGER trg_liquidacion_bitacora_upd AFTER UPDATE ON liquidacion
FOR EACH ROW CALL registrar_bitacora('liquidacion', 'UPDATE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'liquidacion_fecha', OLD.liquidacion_fecha,
              'liquidacion_capital', OLD.liquidacion_capital,
              'liquidacion_mora', OLD.liquidacion_mora),
  JSON_OBJECT('inversion_num', NEW.inversion_num,
              'liquidacion_fecha', NEW.liquidacion_fecha,
              'liquidacion_capital', NEW.liquidacion_capital,
              'liquidacion_mora', NEW.liquidacion_mora));

CREATE TRIGGER trg_liquidacion_bitacora_del AFTER DELETE ON liquidacion
FOR EACH ROW CALL registrar_bitacora('liquidacion', 'DELETE',
  JSON_OBJECT('inversion_num', OLD.inversion_num,
              'liquidacion_fecha', OLD.liquidacion_fecha,
              'liquidacion_capital', OLD.liquidacion_capital,
              'liquidacion_mora', OLD.liquidacion_mora),
  NULL);

-- Protección de la bitácora
CREATE TRIGGER trg_bitacora_proteger_upd BEFORE UPDATE ON bitacora
FOR EACH ROW SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'La bitácora no admite la operación UPDATE';

CREATE TRIGGER trg_bitacora_proteger_del BEFORE DELETE ON bitacora
FOR EACH ROW SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'La bitácora no admite la operación DELETE';
