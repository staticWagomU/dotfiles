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
#c::Run, C:\Program Files\npp.8.1.9.3.portable.x64\notepad++.exe
return

; Pressing the win + f key execute sakura editor. 
#f::Run, C:\Program Files (x86)\sakura\sakura.exe
return


#n::Run, C:\Program Files (x86)\Neovim\bin\nvim-qt.exe
return

; Capture screenshot
#b::
  Send, !{PrintScreen}
return
