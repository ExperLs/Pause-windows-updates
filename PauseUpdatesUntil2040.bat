@echo off
setlocal EnableExtensions
chcp 65001 >nul

:: Request administrator privileges if needed
fltmc >nul 2>&1
if errorlevel 1 (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "KEY=HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
set "BACKUP=%USERPROFILE%\Desktop\WindowsUpdate-backup.reg"

 echo.
echo Creating a backup of the current Windows Update settings...
reg.exe export "%KEY%" "%BACKUP%" /y >nul 2>&1
if errorlevel 1 (
    echo WARNING: Could not export a backup. Continuing anyway.
)

for /f "usebackq delims=" %%A in (`powershell.exe -NoProfile -Command "(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')"`) do set "START=%%A"
for /f "usebackq delims=" %%A in (`powershell.exe -NoProfile -Command "(Get-Date -Year 2040 -Month 1 -Day 1).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')"`) do set "END=%%A"
for /f "usebackq delims=" %%A in (`powershell.exe -NoProfile -Command "[int][Math]::Ceiling(((Get-Date -Year 2040 -Month 1 -Day 1) - (Get-Date)).TotalDays)"`) do set "DAYS=%%A"

if not defined START goto :failed
if not defined END goto :failed
if not defined DAYS goto :failed

 echo Setting Windows Update pause dates...
reg.exe add "%KEY%" /v FlightSettingsMaxPauseDays /t REG_DWORD /d %DAYS% /f >nul || goto :failed
reg.exe add "%KEY%" /v PauseUpdatesStartTime /t REG_SZ /d "%START%" /f >nul || goto :failed
reg.exe add "%KEY%" /v PauseUpdatesExpiryTime /t REG_SZ /d "%END%" /f >nul || goto :failed
reg.exe add "%KEY%" /v PauseFeatureUpdatesStartTime /t REG_SZ /d "%START%" /f >nul || goto :failed
reg.exe add "%KEY%" /v PauseFeatureUpdatesEndTime /t REG_SZ /d "%END%" /f >nul || goto :failed
reg.exe add "%KEY%" /v PauseQualityUpdatesStartTime /t REG_SZ /d "%START%" /f >nul || goto :failed
reg.exe add "%KEY%" /v PauseQualityUpdatesEndTime /t REG_SZ /d "%END%" /f >nul || goto :failed

echo.
echo Registry settings have been written for a pause until 01.01.2040.
echo Restart the PC, then check Settings ^> Windows Update.
echo.
echo Backup: %BACKUP%
echo Note: Windows may ignore or reset these internal settings in some builds.
echo This does not guarantee that every type of update is paused until 2040.
echo.
pause
exit /b 0

:failed
echo.
echo ERROR: One or more registry values could not be set.
echo Check that you approved the administrator prompt.
echo If a backup was created, it is here: %BACKUP%
echo.
pause
exit /b 1
