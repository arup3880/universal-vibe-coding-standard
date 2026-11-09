@echo off
title Install Universal Vibe Coding Standard
echo ==========================================================
echo  Installing Universal Vibe Coding Standard...
echo ==========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-on-another-system.ps1"
echo.
pause
