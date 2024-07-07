@echo off
setlocal enabledelayedexpansion

REM Check if the user provided a zip file path
if "%~1"=="" (
  echo Usage: %~nx0 ^<path to zip file^>
  exit /b 1
)

REM Define the zip file path
set "zip_file_path=%~1"

REM Check if the zip file exists
if not exist "%zip_file_path%" (
  echo Error: Zip file not found!
  exit /b 1
)

echo Zip file found: %zip_file_path%

REM Create a temporary directory for extraction
set "temp_dir=%temp%\%random%"
mkdir "%temp_dir%"

REM Check if the temporary directory was created successfully
if not exist "%temp_dir%" (
  echo Error: Failed to create temporary directory!
  exit /b 1
)

echo Temporary directory created: %temp_dir%

REM Unzip only the files/mobile directory into the temporary directory
powershell -command "Expand-Archive -Path '%zip_file_path%' -DestinationPath '%temp_dir%'"

REM Check if unzip was successful
if errorlevel 1 (
  echo Error: Failed to unzip files!
  rd /s /q "%temp_dir%"
  exit /b 1
)

echo Files unzipped successfully.
echo %temp_dir%