@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ================================
REM CONFIGURATION
REM ================================
set RAMDISK=Y:\profileFf
set PROFILE_DISK=%APPDATA%\Mozilla\Firefox\Profiles\xxxxxxx.default
set FIREFOX_EXE=C:\Program Files\Mozilla Firefox\firefox.exe

REM ================================
REM CREATION RAMDISK SI BESOIN
REM ================================
if not exist "%RAMDISK%" mkdir "%RAMDISK%"

REM ================================
REM COPIE INITIALE (DISQUE -> RAM)
REM ================================
robocopy "%PROFILE_DISK%" "%RAMDISK%" /MIR ^
 /R:0 /W:0 ^
 /XD "safebrowsing" "startupCache" ^
 /XF *.sqlite-wal *.sqlite-shm

REM ================================
REM LANCEMENT FIREFOX
REM ================================
"%FIREFOX_EXE%" -profile "%RAMDISK%"

REM ================================
REM BOUCLE DE SAUVEGARDE
REM ================================
:loop

REM Firefox toujours actif ?
tasklist /FI "IMAGENAME eq firefox.exe" | find /I "firefox.exe" >nul
if errorlevel 1 goto end_firefox

REM Sauvegarde périodique
robocopy "%RAMDISK%" "%PROFILE_DISK%" /MIR ^
 /R:0 /W:0 ^
 /XD "safebrowsing" "startupCache" ^
 /XF *.sqlite-wal *.sqlite-shm

REM Attente 5 minutes
timeout /t 300 >nul
goto loop

REM ================================
REM SAUVEGARDE FINALE
REM ================================
:end_firefox
robocopy "%RAMDISK%" "%PROFILE_DISK%" /MIR ^
 /R:0 /W:0 ^
 /XD "safebrowsing" "startupCache" ^
 /XF *.sqlite-wal *.sqlite-shm

echo.
echo Sauvegarde finale terminee.
exit