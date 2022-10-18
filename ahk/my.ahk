#include C:\Program Files\AutoHotkey\Lib\b.ahk

; Load script
; Shift+Ctrl+F5
^+F5::Reload
return

; Set Lock keys permanently
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff
SetScrollLockState, AlwaysOff
return

; Pressing the win + z key execute Tablacus Explorer. 
#z::Run, C:\Program Files\te220307\TE64.exe
return

; Pressing the win + Enter key execute notepad. 
#ENTER::Run, C:\Windows\notepad.exe
return

; Pressing the win + c key execute notepad++. 
#f::Run, C:\Program Files\Notepad++\notepad++.exe
return

; Pressing the win + f key execute sakura editor. 
#!f::Run, C:\Program Files\sakura\sakura.exe
return

#n::Run, C:\Program Files\Vim\vim90\gvim.exe
return

; Capture screenshot
#b::
  Send, !{PrintScreen}
return

Term()
{
if(FileExist("C:\Program Files\Wezterm\wezterm-gui.exe ")) 
	{
		Run, C:\Program Files\Wezterm\wezterm-gui.exe
	} else 
	{
		Run, %LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe

	}
}
#\::Term()
return

#c::Run, %LOCALAPPDATA%\Programs\Microsoft VS Code\Code.exe
return

#!c::Run, %LOCALAPPDATA%\Programs\Microsoft VS Code Insiders\Code - Insiders.exe
return
