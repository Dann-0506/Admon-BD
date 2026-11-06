# Implementación del Sistema de Inversiones

Scripts para construir el sistema descrito en el manual técnico: dos instancias de PostgreSQL 17.7 y dos de MySQL 8.0.39 en un equipo con Windows, con su esquema, datos de prueba, bitácora, tablespaces, particionamiento, segmentación e índices.

Todo el código proviene del manual. Cada archivo indica en su encabezado quién lo ejecuta, en qué conexión y de qué sección del manual sale.

## Contenido

| Carpeta | Contenido |
|---|---|
| `postgresql/` | Scripts de PostgreSQL. Los números 01 a 09 y 12 se usan en ambas instancias; 10 y 11 solo en la primera. |
| `postgresql/instancia2/` | Scripts exclusivos de la segunda instancia: tablespaces, particionamiento y segmentación. |
| `mysql/` | Igual que `postgresql/`, para MySQL. |
| `mysql/instancia2/` | Igual que `postgresql/instancia2/`, para MySQL. |
| `windows/` | Comandos de Windows: directorios, segundas instancias y copia de datos. Se ejecutan en una terminal `cmd` abierta como administrador. |
| `consultas/` | Consultas de los objetivos, por gestor. `objetivo1.sql` y `objetivo4.sql` sirven para las dos instancias; `instancia1/` e `instancia2/` contienen los objetivos 2, 3 y 5 de cada una. Sirven para comprobar que cada instancia quedó bien construida. |

## Lo que no cubren estos archivos

1. **La instalación de los gestores.** Se hace con los instaladores oficiales y sus opciones por defecto (servicios `postgresql-x64-17` y `MySQL80`, puertos 5432 y 3306).
2. **La variable `PATH`.** Los directorios `bin` de ambos gestores deben estar en `PATH` para ejecutar `psql`, `pg_dump`, `initdb`, `mysql`, `mysqldump` y `mysqld` (capítulo 2). Puede configurarse con el archivo opcional descrito más abajo.
3. **La edición de los archivos de configuración** de la primera instancia: `postgresql.conf`, `pg_hba.conf` y `my.ini`, con los valores de las tablas del capítulo 2 y el parámetro `innodb_directories` del capítulo 9. La segunda instancia copia esos archivos, así que deben estar completos antes de crearla.
4. **El firewall de Windows**, para conexiones desde otros equipos a los puertos 5432, 5434, 3306 y 3308. Puede configurarse con el archivo opcional descrito más abajo.
5. **El mantenimiento anual de las particiones** (capítulo 11).

## Archivo opcional: `PATH` y firewall

`windows\00_opcional_path_firewall.cmd` hace dos cambios en Windows, ambos globales y permanentes hasta que se revierten:

- Agrega los directorios `bin` de ambos gestores a la variable `PATH` del sistema, sin duplicarlos.
- Crea dos reglas de entrada en el firewall, `Inversiones - PostgreSQL` (puertos 5432 y 5434) e `Inversiones - MySQL` (puertos 3306 y 3308), limitadas al perfil de red **privado** y a la **subred local**.

Al terminar muestra el perfil de la red actual. Windows suele asignar el perfil **Público** a una red nueva, como un hotspot; en ese caso las reglas no se aplican y la red debe marcarse como privada en la configuración de Windows.

Las reglas exponen los servidores a los equipos de la subred. PostgreSQL limita el acceso con `pg_hba.conf`, pero en MySQL los usuarios aceptan conexiones desde cualquier origen, así que la protección depende de sus contraseñas. Si no se necesitan conexiones remotas, no ejecutes este archivo y agrega los directorios a `PATH` a mano.

`windows\99_revertir_path_firewall.cmd` deshace ambos cambios: quita esos directorios de `PATH` y elimina las dos reglas. Si alguno de los directorios ya estaba en `PATH` antes de ejecutar el archivo opcional, también se quita.

## Cuentas y bitácora

Las cuentas administrativas (`dlandero`, `enovoa`, `respaldo`) son personales; las operativas (`op_gerente`, `op_ejecutivo`, `op_tesoreria`) son compartidas por rol. Quien use una cuenta operativa debe identificarse al inicio de **cada transacción** que modifique datos, o el trigger de bitácora rechaza el cambio:

```
-- PostgreSQL
BEGIN;
SET LOCAL inversiones.usuario = 'pzuniga';
...
COMMIT;

-- MySQL
START TRANSACTION;
SET @usuario = 'pzuniga';
...
COMMIT;
```

La bitácora guarda el rol (`bitacora_rol`), el usuario (`bitacora_usuario`) y la IP (`bitacora_ip`). En MySQL, `mysql\04_root_privilegios.sql` otorga al DBA la lectura de `mysql.role_edges`, de donde se obtiene el rol.

## Contraseñas

- Las cuentas del sistema usan las contraseñas del manual: `Dlandero#2026`, `Enovoa#2026` y `Respaldo#2026` (administrativas), y `OpGerente#2026`, `OpEjecutivo#2026` y `OpTesoreria#2026` (operativas, compartidas por rol).
- Las de los superusuarios `postgres` y `root` las define quien instala. En `mysql/00_root_cuentas_loopback.sql`, sustituye `********` por la contraseña de `root` antes de ejecutarlo.
- `windows/03_mysql_instancia2.cmd` pide la contraseña de `root` de la segunda instancia. No debe contener los caracteres `& | < > ^ %`, que la terminal interpreta.

## Cómo se ejecutan

Desde esta carpeta. Los comandos piden la contraseña del usuario indicado.

```
psql -h localhost -p <puerto> -U <usuario> -d <base> -v ON_ERROR_STOP=1 -f <script>
mysql -h localhost -P <puerto> -u <usuario> -p [inversiones] < <script>
```

En las tablas siguientes, *Base* indica la base de datos de la conexión: `postgres`, `inversiones` o ninguna (en MySQL).

## Primera instancia de PostgreSQL (puerto 5432)

Requisito: `postgresql.conf` y `pg_hba.conf` configurados (capítulo 2).

| Paso | Ejecuta | Base | Script |
|---|---|---|---|
| 1 | `postgres` | `postgres` | `postgresql\01_postgres_rol_dba.sql` |
| 2 | `postgres` | `postgres` | `postgresql\02_postgres_base_datos.sql` |
| 3 | `dlandero` | `inversiones` | `postgresql\03_dba_roles_usuarios.sql` |
| 4 | `dlandero` | `inversiones` | `postgresql\04_dba_esquema.sql` |
| 5 | `dlandero` | `inversiones` | `postgresql\05_dba_tablas.sql` |
| 6 | `dlandero` | `inversiones` | `postgresql\06_dba_objetos.sql` |
| 7 | `dlandero` | `inversiones` | `postgresql\07_dba_permisos.sql` |
| 8 | `dlandero` | `inversiones` | `postgresql\08_dba_datos.sql` |
| 9 | `dlandero` | `inversiones` | `postgresql\09_dba_bitacora.sql` |
| 10 | Administrador | — | `windows\01_directorios_tablespaces.cmd` (crea también los de MySQL) |
| 11 | `postgres` | `postgres` | `postgresql\10_postgres_tablespaces.sql` |
| 12 | `dlandero` | `inversiones` | `postgresql\11_dba_tablespaces.sql` |
| 13 | `dlandero` | `inversiones` | `postgresql\12_dba_indices.sql` |

## Primera instancia de MySQL (puerto 3306)

El orden de la configuración de `my.ini` importa:

1. Ejecuta `mysql\00_root_cuentas_loopback.sql` como `root` **antes** de activar `skip_name_resolve`. Sin esas cuentas, `root` ya no puede conectarse desde el propio equipo.
2. Configura el resto de `my.ini` (capítulo 2) y el parámetro `innodb_directories` (capítulo 9), y reinicia el servicio `MySQL80`. El paso 6 requiere `log_bin_trust_function_creators = ON`.

| Paso | Ejecuta | Base | Script |
|---|---|---|---|
| 1 | `root` | — | `mysql\01_root_rol_dba.sql` |
| 2 | `dlandero` | — | `mysql\02_dba_base_datos.sql` |
| 3 | `dlandero` | — | `mysql\03_dba_roles_usuarios.sql` |
| 4 | `root` | — | `mysql\04_root_privilegios.sql` |
| 5 | `dlandero` | `inversiones` | `mysql\05_dba_tablas.sql` |
| 6 | `dlandero` | `inversiones` | `mysql\06_dba_objetos.sql` |
| 7 | `dlandero` | `inversiones` | `mysql\07_dba_permisos.sql` |
| 8 | `dlandero` | `inversiones` | `mysql\08_dba_datos.sql` |
| 9 | `dlandero` | `inversiones` | `mysql\09_dba_bitacora.sql` |
| 10 | Administrador | — | `windows\01_directorios_tablespaces.cmd`, si no se ejecutó antes |
| 11 | `root` | — | `mysql\10_root_tablespaces.sql` |
| 12 | `dlandero` | `inversiones` | `mysql\11_dba_tablespaces.sql` |
| 13 | `dlandero` | `inversiones` | `mysql\12_dba_indices.sql` |

## Segunda instancia de PostgreSQL (puerto 5434)

Requisito: la primera instancia completa. Los datos no se cargan de nuevo: se copian de la primera.

| Paso | Ejecuta | Base | Script |
|---|---|---|---|
| 1 | Administrador | — | `windows\02_pg_instancia2.cmd` (pide la contraseña de `postgres`) |
| 2 | `postgres` | `postgres` | `postgresql\01_postgres_rol_dba.sql` |
| 3 | `postgres` | `postgres` | `postgresql\02_postgres_base_datos.sql` |
| 4 | `dlandero` | `inversiones` | `postgresql\03` a `postgresql\07`, en orden |
| 5 | `dlandero` | — | `windows\04_pg_copia_datos.cmd` |
| 6 | `dlandero` | `inversiones` | `postgresql\09_dba_bitacora.sql` |
| 7 | `postgres` | `postgres` | `postgresql\instancia2\10_postgres_tablespaces.sql` |
| 8 | `dlandero` | `inversiones` | `postgresql\instancia2\11_dba_tablespaces.sql` |
| 9 | `dlandero` | `inversiones` | `postgresql\instancia2\20_dba_particionamiento.sql` |
| 10 | `dlandero` | `inversiones` | `postgresql\instancia2\30_dba_segmentacion.sql` |
| 11 | `dlandero` | `inversiones` | `postgresql\12_dba_indices.sql` |

## Segunda instancia de MySQL (puerto 3308)

Requisito: la primera instancia completa, con su `my.ini` definitivo. No se ejecuta `mysql\00_root_cuentas_loopback.sql`: el paso 1 crea esas cuentas al inicializar la instancia.

| Paso | Ejecuta | Base | Script |
|---|---|---|---|
| 1 | Administrador | — | `windows\03_mysql_instancia2.cmd` (pide la contraseña de `root`) |
| 2 | `root` | — | `mysql\01_root_rol_dba.sql` |
| 3 | `dlandero` | — | `mysql\02_dba_base_datos.sql` y `mysql\03_dba_roles_usuarios.sql` |
| 4 | `root` | — | `mysql\04_root_privilegios.sql` |
| 5 | `dlandero` | `inversiones` | `mysql\05` a `mysql\07`, en orden |
| 6 | `dlandero` | — | `windows\05_mysql_copia_datos.cmd` |
| 7 | `dlandero` | `inversiones` | `mysql\09_dba_bitacora.sql` |
| 8 | `root` | — | `mysql\instancia2\10_root_tablespaces.sql` |
| 9 | `dlandero` | `inversiones` | `mysql\instancia2\11_dba_tablespaces.sql` |
| 10 | `dlandero` | `inversiones` | `mysql\instancia2\20_dba_particionamiento.sql` |
| 11 | `dlandero` | `inversiones` | `mysql\instancia2\30_dba_segmentacion.sql` |
| 12 | `dlandero` | `inversiones` | `mysql\12_dba_indices.sql` |

## Comprobación

Ejecuta las consultas de `consultas\` en cada instancia, con `op_gerente` o cualquier cuenta de operación:

- Primera instancia (puertos 5432 y 3306): `objetivo1.sql`, `objetivo4.sql` y los de `instancia1\`.
- Segunda instancia (puertos 5434 y 3308): `objetivo1.sql`, `objetivo4.sql` y los de `instancia2\`. Estos usan las vistas de la segmentación (`interes_saldo` e `inversion_estado`, creadas por `instancia2\30_dba_segmentacion.sql`).

Las dos versiones de los objetivos 2, 3 y 5 devuelven los mismos datos (los cálculos usan la fecha del sistema); solo cambia la presentación de cada cliente.

| Objetivo | Resultado esperado |
|---|---|
| 1 | Un renglón: cliente 1, José Luis Hernández García, 1 inversión, 75000.00 |
| 2 | Inversiones 16, 18, 20 y 17, con dos periodos sin pagar cada una. Los días vencida y la mora estimada dependen de la fecha en que se consulta |
| 3 | Inversión 10, liquidada, mora pagada 1250.00; inversión 35, vigente, mora pagada 7.50 |
| 4 | Pagaré `0018/2024`, inversión 21, sin aval; 10 periodos (6 a 15): el 6 con dos pagos y el último posterior a su fecha final, los periodos 7 a 13 pagados y los periodos 14 y 15 con saldo de 1700.00 |
| 5 | Inversiones 36 a 40, todas vigentes |

La carga deja 25 clientes, 40 inversiones, 639 periodos de interés, 478 pagos, 15 liquidaciones y la bitácora vacía.
