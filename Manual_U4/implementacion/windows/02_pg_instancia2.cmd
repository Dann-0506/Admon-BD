@echo off
rem Segunda instancia de PostgreSQL (puerto 5434)
rem Ejecutar en una terminal cmd abierta como administrador.
rem Generado a partir del manual tecnico.

rem Directorio de la instancia
mkdir C:\instancias\pg2
icacls C:\instancias\pg2 /grant "NT AUTHORITY\NetworkService:(OI)(CI)F"

rem Inicializacion: solicita la contrasena del superusuario postgres
initdb -D C:\instancias\pg2\data -U postgres -E UTF8 -A scram-sha-256 -W

rem Configuracion copiada de la primera instancia
copy /Y "C:\Program Files\PostgreSQL\17\data\postgresql.conf" ^
  C:\instancias\pg2\data
copy /Y "C:\Program Files\PostgreSQL\17\data\pg_hba.conf" ^
  C:\instancias\pg2\data

rem Se cambia unicamente el puerto: en postgresql.conf prevalece el ultimo valor
echo port = 5434>> C:\instancias\pg2\data\postgresql.conf

rem Directorios de los tablespaces
mkdir C:\tablespaces\pg2\catalogos
mkdir C:\tablespaces\pg2\operacion
mkdir C:\tablespaces\pg2\bitacora
icacls C:\tablespaces\pg2 /grant "NT AUTHORITY\NetworkService:(OI)(CI)F"

rem Servicio
pg_ctl register -N postgresql-x64-17-2 -D C:\instancias\pg2\data ^
  -U "NT AUTHORITY\NetworkService" -S auto
net start postgresql-x64-17-2
