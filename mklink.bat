@echo off
setlocal enabledelayedexpansion

REM nvimのシンボリックリンクを作成
mklink /D %LOCALAPPDATA%\nvim %USERPROFILE%\dotvim\nvim

REM vimのシンボリックリンクを作成
REM dir /B /A:Dでディレクトリのシンボリックリンクを作成する
for /f %%i in ('dir /B /A:D %USERPROFILE%\dotvim\vim') do (
  mklink /D %USERPROFILE%\vimfiles\%%i %USERPROFILE%\dotvim\vim\%%i
)

REM dir /B /A-Dでファイルのシンボリックリンクを作成する
for /f %%i in ('dir /B /A-D %USERPROFILE%\dotvim\vim') do (
  mklink %USERPROFILE%\vimfiles\%%i %USERPROFILE%\dotvim\vim\%%i
)
