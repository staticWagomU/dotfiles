if ($env:WT_PROFILE_ID) {
	oh-my-posh init pwsh | Invoke-Expression
    Import-Module oh-my-posh
    Set-PoshPrompt -Theme avit
}
