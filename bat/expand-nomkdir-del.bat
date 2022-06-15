
@echo off
:loop
if "%~1" == "" goto end
if "%~x1" == ".zip" (powershell expand-archive %1 %~p1 -Force)
if "%~x1" == ".zip" (del %1)
shift
goto loop
:end
