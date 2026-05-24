@echo off
setlocal
cd /d "%~dp0.."
echo.
echo Running AI-SKILLS setup...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-windows.ps1"
if errorlevel 1 (
  echo.
  echo Setup failed. If mklink failed, try "Run as administrator" once.
  pause
  exit /b 1
)
echo.
pause
endlocal
