@echo off

prompt $T$B$S$P$_$$$S
doskey /macrofile=%USERPROFILE%\init.macros

if "%CMD_INIT_SCRIPT_LOADED%" neq "" goto :eof
set CMD_INIT_SCRIPT_LOADED=1

set LANG=ja_JP.UTF-8

cls
