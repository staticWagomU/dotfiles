@echo off
setlocal enabledelayedexpansion
for /F %%A in ('dir .\config\vim /B') do (
  mklink /H %USERPROFILE%\vimfiles\%%A %USERPROFILE%\dotfiles\config\vim\%%A
)
endlocal
