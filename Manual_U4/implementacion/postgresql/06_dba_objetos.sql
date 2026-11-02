-- ==========================================================================
-- PostgreSQL · Procedimiento y triggers de validación
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Implementación física > PostgreSQL > Objetos programados
-- ==========================================================================

SET client_encoding = 'UTF8';
SET ROLE rol_admin_bd;

CREATE PROCEDURE generar_tabla_interes(p_inversion_num INT)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = inversiones
AS $$
DECLARE
  v        inversion%ROWTYPE;
  v_monto  NUMERIC(14,2);
  v_inicio DATE;
  v_fin    DATE;
BEGIN
  SELECT * INTO v FROM inversion WHERE inversion_num = p_inversion_num;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'La inversión % no existe', p_inversion_num;
  END IF;

  IF EXISTS (SELECT 1 FROM interes WHERE inversion_num = p_inversion_num) THEN
    RAISE EXCEPTION 'La inversión % ya tiene tabla de interés',
      p_inversion_num;
  END IF;

  v_monto  := round(v.inversion_capital * v.inversion_tasa / 100, 2);
  v_inicio := v.pagare_fecha;
  v_fin    := (date_trunc('month', v.pagare_fecha) + INTERVAL '1 month'
               + (v.inversion_dia_pago - 1) * INTERVAL '1 day')::DATE;

  IF v_fin > v.inversion_fecha_vencimiento THEN
    RAISE EXCEPTION 'El vencimiento es anterior al primer día de pago';
  END IF;

  WHILE v_fin <= v.inversion_fecha_vencimiento LOOP
    INSERT INTO interes (inversion_num, interes_fecha_inicial,
                         interes_fecha_final, interes_monto)
    VALUES (p_inversion_num, v_inicio, v_fin, v_monto);
    v_inicio := v_fin;
    v_fin    := (v_fin + INTERVAL '1 month')::DATE;
  END LOOP;
END;
$$;

CREATE FUNCTION fn_validar_aval() RETURNS trigger
LANGUAGE plpgsql
SET search_path = inversiones
AS $$
BEGIN
  IF NEW.aval_num IS NOT NULL AND
     (SELECT aval_rfc FROM aval WHERE aval_num = NEW.aval_num) =
     (SELECT cliente_rfc FROM cliente WHERE cliente_num = NEW.cliente_num)
  THEN
    RAISE EXCEPTION 'El aval no puede ser el cliente de la inversión';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_inversion_aval
  BEFORE INSERT OR UPDATE OF aval_num, cliente_num ON inversion
  FOR EACH ROW EXECUTE FUNCTION fn_validar_aval();

CREATE FUNCTION fn_validar_liquidacion() RETURNS trigger
LANGUAGE plpgsql
SET search_path = inversiones
AS $$
DECLARE
  v_capital      NUMERIC(14,2);
  v_vencimiento  DATE;
BEGIN
  SELECT inversion_capital, inversion_fecha_vencimiento
    INTO v_capital, v_vencimiento
  FROM inversion
  WHERE inversion_num = NEW.inversion_num;

  IF NEW.liquidacion_capital <> v_capital THEN
    RAISE EXCEPTION 'El capital liquidado debe ser igual al invertido (%)',
      v_capital;
  END IF;

  IF NEW.liquidacion_fecha < v_vencimiento THEN
    RAISE EXCEPTION 'La liquidación no puede ser anterior al vencimiento (%)',
      v_vencimiento;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_liquidacion_validar
  BEFORE INSERT OR UPDATE ON liquidacion
  FOR EACH ROW EXECUTE FUNCTION fn_validar_liquidacion();
