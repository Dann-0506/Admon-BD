@echo off
rem Segunda instancia de MySQL (puerto 3308)
rem Ejecutar en una terminal cmd abierta como administrador.
rem Generado a partir del manual tecnico.

rem Directorio de la instancia y copia de my.ini
mkdir C:\instancias\mysql2
icacls C:\instancias\mysql2 /grant "NT AUTHORITY\NetworkService:(OI)(CI)F"
copy "C:\ProgramData\MySQL\MySQL Server 8.0\my.ini" C:\instancias\mysql2

rem Parametros propios de la instancia. Una seccion [mysqld] posterior
rem prevalece sobre los valores anteriores del mismo archivo.
(
echo.
echo [mysqld]
echo port=3308
echo datadir="C:/instancias/mysql2/data"
echo innodb_directories="C:/tablespaces/mysql2"
echo mysqlx_port=33070
) >> C:\instancias\mysql2\my.ini

rem Archivo de inicializacion con la contrasena del superusuario root
set /p ROOTPASS="Contrasena para root: "
(
echo ALTER USER 'root'@'localhost' IDENTIFIED BY '%ROOTPASS%';
echo CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY '%ROOTPASS%';
echo GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
echo CREATE USER 'root'@'::1' IDENTIFIED BY '%ROOTPASS%';
echo GRANT ALL PRIVILEGES ON *.* TO 'root'@'::1' WITH GRANT OPTION;
) > C:\instancias\mysql2\inicial.sql
set ROOTPASS=

rem Inicializacion
mysqld --defaults-file="C:\instancias\mysql2\my.ini" --initialize ^
  --init-file="C:/instancias/mysql2/inicial.sql" --console
del C:\instancias\mysql2\inicial.sql

rem Directorios de los tablespaces (sin bitacora)
mkdir C:\tablespaces\mysql2\catalogos
mkdir C:\tablespaces\mysql2\operacion
icacls C:\tablespaces\mysql2 /grant "NT AUTHORITY\NetworkService:(OI)(CI)F"

rem Servicio
mysqld --install MySQL80-2 --defaults-file="C:\instancias\mysql2\my.ini"
sc config MySQL80-2 obj= "NT AUTHORITY\NetworkService" password= ""
net start MySQL80-2
