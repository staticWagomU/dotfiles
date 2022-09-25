if(-not $env:path.Split(';').Contains('.')){
  $env:path += ";."
}

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/avit.omp.json" | Invoke-Expression
function git_status() {git status}

function mkdir_cd {
  [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Path
        )

      New-Item -Path $Path -ItemType Directory

      Set-Location -Path $Path
}

function mkdir_cd_cls {
  [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Path
        )

      New-Item -Path $Path -ItemType Directory

      Set-Location -Path $Path
      Clear-Host
}

function ex{exit}
function cd1{cd ..\}
function cd2{cd ..\..\}
function cd3{cd ..\..\..\}

Set-Alias csl Clear-Host
Set-Alias cl Clear-Host
Set-Alias n nvim
Set-Alias v vim
Set-Alias gs git_status
Set-Alias mcd mkdir_cd
Set-Alias mccd mkdir_cd_cls
Set-Alias :q ex
Set-Alias ... cd1
Set-Alias .... cd2
Set-Alias ..... cd3
