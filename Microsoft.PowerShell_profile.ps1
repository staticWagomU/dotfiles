if(-not $env:path.Split(';').Contains('.')){
    $env:path += ";."
}

oh-my-posh init pwsh | Invoke-Expression
Import-Module oh-my-posh
        Set-PoshPrompt -Theme avit

function git_status() {git status}

Set-Alias csl Clear-Host
Set-Alias n nvim
Set-Alias v vim
Set-Alias gs git_status

