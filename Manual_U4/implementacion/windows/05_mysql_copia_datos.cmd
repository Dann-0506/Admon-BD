@echo off
rem Copia de los datos a la segunda instancia de MySQL (DBA)
rem Ejecutar en una terminal cmd abierta como administrador.
rem Generado a partir del manual tecnico.

rem Solicita la contrasena de dlandero en cada comando
mysqldump -h localhost -P 3306 -u dlandero -p --no-create-info --skip-triggers ^
  --no-tablespaces --single-transaction inversiones > inversiones_datos.sql
mysql -h localhost -P 3308 -u dlandero -p inversiones < inversiones_datos.sql
