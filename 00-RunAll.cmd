@echo off
setlocal

REM =============================================================================================== 
REM Run as Administrator.
REM Purpose: Runs a collection of 7 PowerShell scripts in the required order.
REM Note: Some steps may require restart machine to complete configuration.
REM ===============================================================================================

echo ===========================
echo Script Collection
echo ===========================

REM Change to the folder where the .cmd file is located
cd /d "%~dp0"

REM ===============================================================================================
REM Each execution block will follow the same structure where:
REM echo. -Adds a blank line for spacing
REM echo [-/7] -Displays the current step in the execution order
REM -NoProfile -ExecutionPolicy Bypass -File "" -Runs PowerShell and executes the script file
REM if errorlevel 1 goto:fail -Error handling
REM ===============================================================================================

echo.
echo [1/7] Rename computer
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Scripts\01-RenameComputer.ps1"
if errorlevel 1 goto :fail

echo.
echo [2/7] Set timezone
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Scripts\03-SetTimeZone.ps1"
if errorlevel 1 goto :fail

echo.
echo [3/7] Configure regional settings
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Scripts\04-SetRegionalSetting.ps1"
if errorlevel 1 goto :fail

echo.
echo [4/7] Config network
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Scripts\06-ConfigNetwork.ps1"
if errorlevel 1 goto :fail

echo.
echo [5/7] Configure DNS servers
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Scripts\07-SetDnsServer.ps1"
if errorlevel 1 goto :fail

echo.
echo [6/7] Join domain
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Scripts\02-JoinDomain.ps1"
if errorlevel 1 goto :fail

echo.
echo [7/7] Install Windows Updates
powershell -NoProfile -ExecutionPolicy Bypass -File ".\Scripts\05-InstallWindowsUpdates.ps1"
if errorlevel 1 goto :fail

echo.
echo The execution of scripts collection was completed successfully.
exit /b 0

:fail
REM If any script fails, the collection will be stopped
echo.
echo The execution of scripts collection has stopped due to an error.
exit /b 1