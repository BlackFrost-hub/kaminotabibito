@echo off
cd /d "%~dp0"

set "SRC=.build\_warcraft_vscode_test.w3x"
set "DST=map.w3x"

if not exist "%SRC%" (
    echo Source file not found: %SRC%
    echo Please build the map first.
    pause
    exit /b 1
)

copy /Y "%SRC%" "%DST%" >nul
if errorlevel 1 (
    echo Copy failed.
    pause
    exit /b 1
)
echo Done: %DST%
pause
exit
