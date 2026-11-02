@echo off
rem Revierte los cambios de 00_opcional_path_firewall.cmd: quita de la
rem variable PATH del sistema los programas de ambos gestores y elimina las
rem reglas del firewall de las cuatro instancias.
rem Ejecutar en una terminal cmd abierta como administrador.

net session >nul 2>&1
if errorlevel 1 (
  echo Este archivo debe ejecutarse en una terminal abierta como administrador.
  exit /b 1
)

powershell -NoProfile -Command "$d = @('C:\Program Files\PostgreSQL\17\bin','C:\Program Files\MySQL\MySQL Server 8.0\bin'); $l = @([Environment]::GetEnvironmentVariable('Path','Machine') -split ';' | Where-Object { $_ -and ($d -notcontains $_) }); [Environment]::SetEnvironmentVariable('Path', ($l -join ';'), 'Machine')"
if errorlevel 1 exit /b 1
echo PATH restaurado.

netsh advfirewall firewall delete rule name="Inversiones - PostgreSQL"
netsh advfirewall firewall delete rule name="Inversiones - MySQL"
