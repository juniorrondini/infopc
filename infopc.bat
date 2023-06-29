@echo off
setlocal enabledelayedexpansion

REM Obter nome de usuário e nome da máquina
set "username=%USERNAME%"
set "computername=%COMPUTERNAME%"

REM Obter endereço IP e gateway configurados
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "Endereço IPv4"') do (
    set "ip=%%a"
    set "ip=!ip:~1!"
)

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "Gateway Padrão"') do (
    set "gateway=%%a"
    set "gateway=!gateway:~1!"
)

REM Obter informações do espaço utilizado no HD (via PowerShell)
for /f "tokens=2 delims=:" %%a in ('powershell -command "(Get-PSDrive -PSProvider 'FileSystem' | Where-Object {$_.Free -ne $null}).Name"') do (
    set "drive=%%a"
    for /f "usebackq tokens=3 delims= " %%b in (`powershell -command "Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq '%%a'} | Select-Object -ExpandProperty Size"`) do (
        set /a "totalspace=%%b/1GB"
        for /f "usebackq tokens=3 delims= " %%c in (`powershell -command "Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq '%%a'} | Select-Object -ExpandProperty FreeSpace"`) do (
            set /a "freespace=%%c/1GB"
            REM Exibir as informações coletadas
            echo.
            echo ------------------------------
            echo Informações do Disco !drive!
            echo ------------------------------
            echo Espaço utilizado: !freespace!GB de !totalspace!GB
            REM Salvar informações em arquivo de texto
            echo. >> "%USERPROFILE%\Desktop\InforPC.txt"
            echo ------------------------------ >> "%USERPROFILE%\Desktop\InforPC.txt"
            echo Informações do Disco !drive! >> "%USERPROFILE%\Desktop\InforPC.txt"
            echo ------------------------------ >> "%USERPROFILE%\Desktop\InforPC.txt"
            echo Espaço utilizado: !freespace!GB de !totalspace!GB >> "%USERPROFILE%\Desktop\InforPC.txt"
        )
    )
)

REM Obter servidores DNS configurados (via PowerShell)
for /f "tokens=*" %%a in ('powershell -command "(Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses"') do (
    set "dns=%%a"
    REM Exibir as informações coletadas
    echo.
    echo ------------------------------
    echo Servidores DNS configurados
    echo ------------------------------
    echo Servidor DNS: !dns!
    REM Salvar informações em arquivo de texto
    echo. >> "%USERPROFILE%\Desktop\InforPC.txt"
    echo ------------------------------ >> "%USERPROFILE%\Desktop\InforPC.txt"
    echo Servidores DNS configurados >> "%USERPROFILE%\Desktop\InforPC.txt"
    echo ------------------------------ >> "%USERPROFILE%\Desktop\InforPC.txt"
    echo Servidor DNS: !dns! >> "%USERPROFILE%\Desktop\InforPC.txt"
)

REM Exibir as informações de rede coletadas
echo.
echo ------------------------------
echo Informações de Rede
echo ------------------------------
echo Nome do usuário: %username%
echo Nome da máquina: %computername%
echo Endereço IP configurado: %ip%
echo Gateway padrão: %gateway%
REM Salvar informações em arquivo de texto
echo. >> "%USERPROFILE%\Desktop\InforPC.txt"
echo ------------------------------ >> "%USERPROFILE%\Desktop\InforPC.txt"
echo Informações de Rede >> "%USERPROFILE%\Desktop\InforPC.txt"
echo ------------------------------ >> "%USERPROFILE%\Desktop\InforPC.txt"
echo Nome do usuário: %username% >> "%USERPROFILE%\Desktop\InforPC.txt"
echo Nome da máquina: %computername% >> "%USERPROFILE%\Desktop\InforPC.txt"
echo Endereço IP configurado: %ip% >> "%USERPROFILE%\Desktop\InforPC.txt"
echo Gateway padrão: %gateway% >> "%USERPROFILE%\Desktop\InforPC.txt"

echo.
echo As informações foram salvas no arquivo InforPC.txt na área de trabalho.

pause
