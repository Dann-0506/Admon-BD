-- ==========================================================================
-- MySQL · Permisos
-- Ejecuta:  dlandero
-- Conexión: base inversiones
-- Origen:   Implementación física > MySQL > Permisos
-- ==========================================================================

SET NAMES utf8mb4;
-- Gerente
GRANT SELECT, UPDATE         ON inversiones.empresa     TO rol_gerente;
GRANT SELECT, INSERT, UPDATE ON inversiones.sucursal    TO rol_gerente;
GRANT SELECT, UPDATE         ON inversiones.cliente     TO rol_gerente;
GRANT SELECT, INSERT, UPDATE ON inversiones.aval        TO rol_gerente;
GRANT SELECT, UPDATE, DELETE ON inversiones.inversion   TO rol_gerente;
GRANT SELECT                 ON inversiones.interes     TO rol_gerente;
GRANT SELECT                 ON inversiones.pago        TO rol_gerente;
GRANT SELECT                 ON inversiones.liquidacion TO rol_gerente;

-- Ejecutivo
GRANT SELECT         ON inversiones.empresa     TO rol_ejecutivo;
GRANT SELECT         ON inversiones.sucursal    TO rol_ejecutivo;
GRANT SELECT, INSERT ON inversiones.cliente     TO rol_ejecutivo;
GRANT UPDATE (cliente_telefono, cliente_direccion)
  ON inversiones.cliente TO rol_ejecutivo;
GRANT SELECT         ON inversiones.aval        TO rol_ejecutivo;
GRANT SELECT, INSERT ON inversiones.inversion   TO rol_ejecutivo;
GRANT SELECT         ON inversiones.interes     TO rol_ejecutivo;
GRANT SELECT         ON inversiones.pago        TO rol_ejecutivo;
GRANT SELECT         ON inversiones.liquidacion TO rol_ejecutivo;
GRANT EXECUTE ON PROCEDURE inversiones.generar_tabla_interes
  TO rol_ejecutivo;

-- Tesorería
GRANT SELECT         ON inversiones.empresa     TO rol_tesoreria;
GRANT SELECT         ON inversiones.sucursal    TO rol_tesoreria;
GRANT SELECT         ON inversiones.cliente     TO rol_tesoreria;
GRANT SELECT         ON inversiones.aval        TO rol_tesoreria;
GRANT SELECT         ON inversiones.inversion   TO rol_tesoreria;
GRANT SELECT         ON inversiones.interes     TO rol_tesoreria;
GRANT SELECT, INSERT ON inversiones.pago        TO rol_tesoreria;
GRANT SELECT, INSERT ON inversiones.liquidacion TO rol_tesoreria;

-- Auditor
GRANT SELECT ON inversiones.* TO rol_auditor;
