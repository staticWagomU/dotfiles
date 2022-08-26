if(-not $env:path.Split(';').Contains('.')){
    $env:path += ";."
}

#if ($env:WT_PROFILE_ID) {
        oh-my-posh init pwsh | Invoke-Expression
        Import-Module oh-my-posh
                Set-PoshPrompt -Theme avit
#Set-PoshPrompt -Theme nordtron
#New-Item (Split-Path -Parent $PROFILE) -type directory -Force
#}


