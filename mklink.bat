del       "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\my.ahk"
mklink /h "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\my.ahk" ".\my.ahk"

del       "%HOME%\AppData\Local\nvim\init.vim" 
mklink /h "%HOME%\AppData\Local\nvim\init.vim" ".\init.vim"

del       "%HOME%\AppData\Roaming\Microsoft\Windows\SendTo\expand.bat" 
mklink /h "%HOME%\AppData\Roaming\Microsoft\Windows\SendTo\expand.bat" ".\expand.bat"
