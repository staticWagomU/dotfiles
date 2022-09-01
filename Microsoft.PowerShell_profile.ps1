if(-not $env:path.Split(';').Contains('.')){
    $env:path += ";."
}

oh-my-posh init pwsh | Invoke-Expression
Import-Module oh-my-posh
        Set-PoshPrompt -Theme avit

Set-Alias csl Clear-Host


