@echo off
REM Run hdcd-telegram binary. Downloads it first if not present.

set "PLUGIN_ROOT=%CLAUDE_PLUGIN_ROOT%"
if "%PLUGIN_ROOT%"=="" set "PLUGIN_ROOT=%~dp0.."

set "DATA_DIR=%CLAUDE_PLUGIN_DATA%"
if "%DATA_DIR%"=="" set "DATA_DIR=%USERPROFILE%\.claude\plugins\data\hdcd-telegram"

set "BINARY=%DATA_DIR%\hdcd-telegram.exe"

if not exist "%BINARY%" (
    powershell -ExecutionPolicy Bypass -File "%PLUGIN_ROOT%\scripts\setup.ps1"
)

"%BINARY%" %*
