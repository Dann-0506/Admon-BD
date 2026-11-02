@echo off
rem Copia de los datos a la segunda instancia de PostgreSQL (DBA)
rem Ejecutar en una terminal cmd abierta como administrador.
rem Generado a partir del manual tecnico.

rem Solicita la contrasena de dlandero en cada comando
pg_dump -h localhost -p 5432 -U dlandero -d inversiones -n inversiones ^
  --data-only -F c -f inversiones_datos.dump
pg_restore -h localhost -p 5434 -U dlandero -d inversiones ^
  --data-only --exit-on-error inversiones_datos.dump
