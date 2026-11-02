@echo off
rem OPCIONAL. Agrega los programas de ambos gestores a la variable PATH del
rem sistema y abre en el firewall los puertos de las cuatro instancias.
rem Las reglas solo admiten conexiones del perfil de red privado y de la
rem subred local. Para deshacer los cambios: 99_revertir_path_firewall.cmd
rem Ejecutar en una terminal cmd abierta como administrador.

net session >nul 2>&1
if errorlevel 1 (
  echo Este archivo debe ejecutarse en una terminal abierta como administrador.
  exit /b 1
)

rem PATH del sistema: agrega cada directorio solo si no esta ya incluido.
rem Se usa PowerShell porque setx trunca la variable a 1024 caracteres.
powershell -NoProfile -Command "$d = @('C:\Program Files\PostgreSQL\17\bin','C:\Program Files\MySQL\MySQL Server 8.0\bin'); $l = @([Environment]::GetEnvironmentVariable('Path','Machine') -split ';' | Where-Object { $_ }); foreach ($x in $d) { if ($l -notcontains $x) { $l += $x } }; [Environment]::SetEnvironmentVariable('Path', ($l -join ';'), 'Machine')"
if errorlevel 1 exit /b 1
echo PATH actualizado. Las terminales abiertas despues de este cambio ya lo usan.

rem Firewall: se eliminan las reglas previas del mismo nombre para no duplicarlas.
netsh advfirewall firewall delete rule name="Inversiones - PostgreSQL" >nul 2>&1
netsh advfirewall firewall delete rule name="Inversiones - MySQL" >nul 2>&1
netsh advfirewall firewall add rule name="Inversiones - PostgreSQL" dir=in action=allow protocol=TCP localport=5432,5434 profile=private remoteip=localsubnet
netsh advfirewall firewall add rule name="Inversiones - MySQL" dir=in action=allow protocol=TCP localport=3306,3308 profile=private remoteip=localsubnet

echo.
echo Las reglas solo se aplican si la red actual tiene el perfil Privado.
echo Perfil de la red actual:
powershell -NoProfile -Command "Get-NetConnectionProfile | Format-Table Name, NetworkCategory -AutoSize"
