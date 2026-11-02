-- ==========================================================================
-- PostgreSQL · Permisos
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Implementación física > PostgreSQL > Permisos
-- ==========================================================================

SET client_encoding = 'UTF8';
SET ROLE rol_admin_bd;

-- Privilegios por defecto de PUBLIC
REVOKE CONNECT, TEMPORARY ON DATABASE inversiones FROM PUBLIC;
REVOKE EXECUTE ON PROCEDURE generar_tabla_interes(INT) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION fn_validar_aval(), fn_validar_liquidacion()
  FROM PUBLIC;

-- Acceso a la base de datos y al esquema
GRANT CONNECT ON DATABASE inversiones
  TO rol_gerente, rol_ejecutivo, rol_tesoreria, rol_auditor, rol_respaldo;
GRANT USAGE ON SCHEMA inversiones
  TO rol_gerente, rol_ejecutivo, rol_tesoreria, rol_auditor, rol_respaldo;

-- Gerente
GRANT SELECT, UPDATE         ON empresa, cliente           TO rol_gerente;
GRANT SELECT, INSERT, UPDATE ON sucursal, aval             TO rol_gerente;
GRANT SELECT, UPDATE, DELETE ON inversion                  TO rol_gerente;
GRANT SELECT                 ON interes, pago, liquidacion TO rol_gerente;
GRANT USAGE ON SEQUENCE sucursal_sucursal_num_seq, aval_aval_num_seq
  TO rol_gerente;

-- Ejecutivo
GRANT SELECT ON empresa, sucursal, aval, interes, pago, liquidacion
  TO rol_ejecutivo;
GRANT SELECT, INSERT ON cliente, inversion TO rol_ejecutivo;
GRANT UPDATE (cliente_telefono, cliente_direccion) ON cliente
  TO rol_ejecutivo;
GRANT USAGE ON SEQUENCE cliente_cliente_num_seq, inversion_inversion_num_seq
  TO rol_ejecutivo;
GRANT EXECUTE ON PROCEDURE generar_tabla_interes(INT) TO rol_ejecutivo;

-- Tesorería
GRANT SELECT ON empresa, sucursal, cliente, aval, inversion, interes
  TO rol_tesoreria;
GRANT SELECT, INSERT ON pago, liquidacion TO rol_tesoreria;

-- Auditor y respaldo
GRANT SELECT ON ALL TABLES IN SCHEMA inversiones TO rol_auditor, rol_respaldo;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA inversiones TO rol_respaldo;

-- Tablas creadas posteriormente
ALTER DEFAULT PRIVILEGES FOR ROLE rol_admin_bd IN SCHEMA inversiones
  GRANT SELECT ON TABLES TO rol_auditor, rol_respaldo;
