@echo off
REM Check if PowerShell is available
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo PowerShell is not installed on this system.
    exit /b 1
)

REM Define the PowerShell script path
set scriptPath=%~dp0bin\convert_images_gui.ps1

REM Check if the script exists
if not exist "%scriptPath%" (
    echo Script %scriptPath% not found.
    exit /b 1
)

REM Run the PowerShell script
powershell -NoProfile -ExecutionPolicy Bypass -File "%scriptPath%"