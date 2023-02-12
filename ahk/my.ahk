;#include C:\Program Files\AutoHotkey\Lib\env.ahk

; Pressing the win + z key execute Tablacus Explorer. 
#z::
{
        Run "C:\Program Files\te220307\TE64.exe"
}

; Pressing the win + Enter key execute notepad. 
#ENTER::
{
        Run "notepad.exe"
}

; Pressing the win + c key execute notepad++. 
;#f::
;{
;        Run C:\Program Files\Notepad++\notepad++.exe
;}

; Pressing the win + f key execute sakura editor. 
;#!f::Run, C:\Program Files\sakura\sakura.exe

;#n::Run, C:\Program Files\Vim\vim90\gvim.exe

Term()
{
        if(FileExist("C:\Program Files\Wezterm\wezterm-gui.exe ")) 
        {
                Run "C:\Program Files\Wezterm\wezterm-gui.exe"
        } else 
        {
                Run "%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe"

        }
}
;#\::{Term()}

;#c::Run, %LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe

;#!c::Run, %LOCALAPPDATA%\Programs\Microsoft VS Code Insiders\Code - Insiders.exe
