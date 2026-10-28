@echo off
setlocal EnableExtensions
title Macw1u Gaming Optimizer - Safe Edition
color 0B

:: Macw1u Gaming Optimizer - Safe Edition
:: Windows 10/11. Uses conservative, reversible settings.
:: No disabling Defender, Windows Update, or essential services.
:: Some actions are maintenance/diagnostics and do not directly raise FPS.

:: Check elevation using Windows security APIs (more reliable than "net session")
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()); if ($p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit 0 } else { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo Requesting Administrator permission...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Start-Process -FilePath '%~f0' -Verb RunAs } catch { exit 1 }"
    if errorlevel 1 (
        echo Could not request Administrator permission. Right-click this file and choose Run as administrator.
        pause
    )
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