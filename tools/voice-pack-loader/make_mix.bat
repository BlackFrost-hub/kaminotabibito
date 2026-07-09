@echo off
setlocal

if "%~3"=="" (
  echo Usage: make_mix.bat loader.dll voice_pack.mpq output.mix
  exit /b 1
)

set "LOADER=%~1"
set "MPQ=%~2"
set "OUT=%~3"

if not exist "%LOADER%" (
  echo Missing loader DLL: %LOADER%
  exit /b 1
)

if not exist "%MPQ%" (
  echo Missing MPQ: %MPQ%
  exit /b 1
)

copy /b "%LOADER%" + "%MPQ%" "%OUT%" >nul
if errorlevel 1 (
  echo Failed to create %OUT%
  exit /b 1
)

echo Created %OUT%
endlocal
