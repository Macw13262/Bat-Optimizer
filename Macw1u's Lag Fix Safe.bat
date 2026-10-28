@echo off
setlocal EnableExtensions
title Macw1u Gaming Optimizer - Safe Edition
color 0B

:: Macw1u Gaming Optimizer - Safe Edition
:: Windows 10/11. Uses conservative, reversible settings.
:: No disabling Defender, Windows Update, or essential services.
:: Some actions are maintenance/diagnostics and do not directly raise FPS.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator permission...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "BACKUP=%USERPROFILE%\Desktop\Macw1u_Gaming_Optimizer_Backup"
if not exist "%BACKUP%" mkdir "%BACKUP%"

echo.
echo ============================================================
echo          MACW1U GAMING OPTIMIZER - SAFE EDITION
echo ============================================================
echo.
echo This script performs 35+ conservative settings, cleanup,
echo maintenance, and diagnostic actions.
echo It cannot guarantee zero lag or higher FPS on every PC.
echo Cosmetic tweaks may change some Windows animations.
echo High Performance can increase heat and battery use on laptops.
echo.
echo A backup folder will be created here:
echo %BACKUP%
echo.
choice /c YN /n /m "Continue? [Y/N]: "
if errorlevel 2 exit /b

echo.
echo [1/35] Trying to create a System Restore point...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Checkpoint-Computer -Description 'Before Macw1u Gaming Optimizer' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop; Write-Host 'Restore point created.' } catch { Write-Host 'Restore point unavailable (System Protection may be off). Continuing.' }"

echo.
echo [2/35] Backing up registry sections before changes...
reg export "HKCU\Software\Microsoft\GameBar" "%BACKUP%\GameBar.reg" /y >nul 2>&1
reg export "HKCU\System\GameConfigStore" "%BACKUP%\GameConfigStore.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" "%BACKUP%\GameDVR.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "%BACKUP%\Personalize.reg" /y >nul 2>&1
reg export "HKCU\Control Panel\Desktop" "%BACKUP%\Desktop.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "%BACKUP%\ExplorerAdvanced.reg" /y >nul 2>&1

echo.
echo [3/35] Enabling automatic Windows Game Mode...
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul

echo.
echo [4/35] Allowing Windows to automatically apply Game Mode...
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul

echo.
echo [5/35] Disabling Game DVR recording...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul

echo.
echo [6/35] Disabling app capture...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul

echo.
echo [7/35] Disabling Game DVR audio capture...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AudioCaptureEnabled /t REG_DWORD /d 0 /f >nul

echo.
echo [8/35] Disabling background/historical capture...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v HistoricalCaptureEnabled /t REG_DWORD /d 0 /f >nul

echo.
echo [9/35] Hiding the Game Bar startup panel...
reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul

echo.
echo [10/35] Dismissing the Game Bar startup tip...
reg add "HKCU\Software\Microsoft\GameBar" /v GamePanelStartupTipIndex /t REG_DWORD /d 3 /f >nul

echo.
echo [11/35] Turning off Windows transparency effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul

echo.
echo [12/35] Disabling minimize/maximize window animation...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul

echo.
echo [13/35] Disabling taskbar animations...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul

echo.
echo [14/35] Making menus open faster (cosmetic; 100 ms)...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 100 /f >nul

echo.
echo [15/35] Disabling full-window drag previews (cosmetic)...
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f >nul

echo.
echo [16/35] Turning off Explorer list-view alpha selection...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul

echo.
echo [17/35] Turning off Explorer list-view shadows...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul

echo.
echo [18/35] Selecting the built-in High Performance plan if available...
powercfg /setactive SCHEME_MIN >nul 2>&1
if %errorlevel% equ 0 (echo High Performance selected.) else (echo Not available; existing plan left unchanged.)
powercfg /getactivescheme

echo.
echo [19/35] Cleaning files in your user TEMP folder...
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
echo Files currently in use are skipped.

echo.
echo [20/35] Cleaning files in the Windows TEMP folder...
del /f /s /q "%WINDIR%\Temp\*" >nul 2>&1
for /d %%D in ("%WINDIR%\Temp\*") do rd /s /q "%%D" >nul 2>&1
echo Files currently in use are skipped.

echo.
echo [21/35] Flushing the DNS resolver cache...
ipconfig /flushdns

echo.
echo [22/35] Asking Windows to optimize the system drive...
echo Windows chooses the appropriate operation for SSD/HDD.
defrag %SystemDrive% /O /U

echo.
echo [23/35] Running an online disk scan (no forced repair/reboot)...
chkdsk %SystemDrive% /scan

echo.
echo [24/35] Checking and repairing Windows component store...
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo [25/35] Checking Windows protected system files...
sfc /scannow

echo.
echo [26/35] Generating a power efficiency diagnostic report...
powercfg /energy /duration 30 /output "%BACKUP%\EnergyReport.html"

echo.
echo [27/35] Saving active power plan details...
powercfg /getactivescheme > "%BACKUP%\ActivePowerPlan.txt" 2>&1

echo.
echo [28/35] Saving Windows and hardware diagnostics...
systeminfo > "%BACKUP%\SystemInfo.txt" 2>&1

echo.
echo [29/35] Saving network diagnostics...
ipconfig /all > "%BACKUP%\NetworkInfo.txt" 2>&1

echo.
echo [30/35] Saving free-space information...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,@{N='FreeGB';E={[math]::Round($_.FreeSpace/1GB,2)}},@{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}} | Format-Table -AutoSize | Out-File -Encoding utf8 '%BACKUP%\DiskSpace.txt'"

echo.
echo [31/35] Opening Windows Game Mode settings...
start "" ms-settings:gaming-gamemode

echo.
echo [32/35] Opening Graphics settings (set your game to High performance if offered)...
start "" ms-settings:display-advancedgraphics

echo.
echo [33/35] Opening display settings to check refresh rate...
start "" ms-settings:display-advanced

echo.
echo [34/35] Opening Storage settings for Windows cleanup options...
start "" ms-settings:storage

echo.
echo [35/35] Opening Startup Apps settings so you can disable unwanted apps yourself...
start "" ms-settings:startupapps

echo.
echo ============================================================
echo                   FINISHED
echo ============================================================
echo Backup and reports: %BACKUP%
echo Restart Windows to apply all changes consistently.
echo.
echo SAFETY NOTES:
echo - This script does not disable Defender, Windows Update, or core services.
echo - Do not disable random services or use registry "ping/FPS tweaks".
echo - Initial game launch after maintenance may briefly stutter while caches rebuild.
echo - If you dislike the visual changes, restore the saved registry sections
echo   or use System Restore if a restore point was successfully created.
echo - High Performance may increase laptop heat and battery use.
echo - For best results, update GPU drivers from the official NVIDIA/AMD/Intel site.
echo.
pause
endlocal
