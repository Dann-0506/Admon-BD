-- ==========================================================================
-- PostgreSQL · Bitácora
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Bitácora > PostgreSQL
-- ==========================================================================

SET client_encoding = 'UTF8';
-- Ejecutado por dlandero en la base de datos inversiones
SET ROLE rol_admin_bd;

CREATE FUNCTION fn_bitacora()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = inversiones
AS $$
BEGIN
  INSERT INTO bitacora (bitacora_fecha, bitacora_usuario, bitacora_tabla,
                        bitacora_operacion, bitacora_ip, bitacora_sesion,
                        bitacora_query, bitacora_dato_anterior,
                        bitacora_dato_nuevo)
  VALUES (LOCALTIMESTAMP, session_user, TG_TABLE_NAME, TG_OP,
          host(inet_client_addr()), pg_backend_pid(), current_query(),
          CASE WHEN TG_OP IN ('UPDATE', 'DELETE') THEN to_jsonb(OLD) END,
          CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN to_jsonb(NEW) END);
  RETURN NULL;
END;
$$;

CREATE TRIGGER trg_empresa_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON empresa
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

CREATE TRIGGER trg_sucursal_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON sucursal
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

CREATE TRIGGER trg_cliente_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON cliente
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

CREATE TRIGGER trg_aval_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON aval
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

CREATE TRIGGER trg_inversion_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON inversion
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

CREATE TRIGGER trg_interes_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON interes
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

CREATE TRIGGER trg_pago_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON pago
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

CREATE TRIGGER trg_liquidacion_bitacora
  AFTER INSERT OR UPDATE OR DELETE ON liquidacion
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora();

-- Protección de la bitácora
CREATE FUNCTION fn_bitacora_proteger()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'La bitácora no admite la operación %', TG_OP;
END;
$$;

CREATE TRIGGER trg_bitacora_proteger
  BEFORE UPDATE OR DELETE ON bitacora
  FOR EACH ROW EXECUTE FUNCTION fn_bitacora_proteger();

CREATE TRIGGER trg_bitacora_truncate
  BEFORE TRUNCATE ON bitacora
  FOR EACH STATEMENT EXECUTE FUNCTION fn_bitacora_proteger();
