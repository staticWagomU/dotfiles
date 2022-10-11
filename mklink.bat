del       "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\my.ahk"
mklink /h "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\my.ahk" ".\my.ahk"

del       "%HOME%\AppData\Roaming\Microsoft\Windows\SendTo\expand.bat" 
mklink /h "%HOME%\AppData\Roaming\Microsoft\Windows\SendTo\expand.bat" ".\expand.bat"

del "%VIM%/_vimrc"
del "%HOME%\_vimrc"
mklink /h "%HOME%\_vimrc" "%HOME%\dotfiles\vim\rc\_vimrc"
del "%HOME%\_gvimrc"
mklink /h "%HOME%\_gvimrc" "%HOME%\dotfiles\vim\rc\gvimrc"
