@echo off
rem Directorios de los tablespaces de la primera instancia de cada gestor
rem Ejecutar en una terminal cmd abierta como administrador.
rem Generado a partir del manual tecnico.

rem PostgreSQL
mkdir C:\tablespaces\pg1\catalogos
mkdir C:\tablespaces\pg1\operacion
mkdir C:\tablespaces\pg1\bitacora
icacls C:\tablespaces\pg1 /grant "NT AUTHORITY\NetworkService:(OI)(CI)F"

rem MySQL
mkdir C:\tablespaces\mysql1\catalogos
mkdir C:\tablespaces\mysql1\operacion
mkdir C:\tablespaces\mysql1\bitacora
icacls C:\tablespaces\mysql1 /grant "NT AUTHORITY\NetworkService:(OI)(CI)F"
