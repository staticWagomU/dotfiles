@echo off
setlocal enabledelayedexpansion
for /F %%A in ('dir .\config\vim /B') do (
  mklink /H %USERPROFILE%\vimfiles\%%A %USERPROFILE%\dotfiles\config\vim\%%A
)
endlocal

mklink /D C:\Users\wagomu\AppData\Local\nvim C:\Users\wagomu\dotfiles\config\nvim
