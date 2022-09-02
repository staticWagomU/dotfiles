if(-not $env:path.Split(';').Contains('.')){
    $env:path += ";."
}

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/avit.omp.json" | Invoke-Expression
function git_status() {git status}

Set-Alias csl Clear-Host
Set-Alias n nvim
Set-Alias v vim
Set-Alias gs git_status

