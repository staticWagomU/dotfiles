# Ghostty から起動する PowerShell のプロファイル。
#
# pwsh は /etc/profile も ~/.profile も読まず、Ghostty は launchd の最小 PATH を
# 引き継がせるだけなので、config/fish/config.fish と同じ探索パスをここで組み直す。

$UserName = Split-Path -Leaf $HOME

# 先頭ほど優先度が高い（fish 側の最終的な PATH 順に合わせている）
$PreferredPaths = @(
    "$HOME/.volta/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.bun/bin"
    "$HOME/.deno/bin"
    "$HOME/.npm-global/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/dotfiles/scripts"
    "/etc/profiles/per-user/$UserName/bin"
    "$HOME/.nix-profile/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/local/sbin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "/Library/Apple/usr/bin"
)

$InheritedPaths = if ($env:PATH) { $env:PATH -split ':' } else { @() }

# Select-Object -Unique は最初の出現順を保つので、優先度がそのまま残る
$env:PATH = (
    ($PreferredPaths + $InheritedPaths) |
        Where-Object { $_ -and (Test-Path -LiteralPath $_) } |
        Select-Object -Unique
) -join ':'

# Ghostty は command を設定すると $SHELL をそのコマンド (pwsh) に書き換えるが、
# $SHELL は他のツールがコマンド実行を委譲する先として使われる
# (fzf, git, claude などが $SHELL -c ... を呼ぶ)。pwsh は POSIX 互換の引数を
# 取らないため、既存の挙動どおり fish を指すように戻す。
$FishPath = "/etc/profiles/per-user/$UserName/bin/fish"
$env:SHELL = if (Test-Path -LiteralPath $FishPath) { $FishPath } else { '/bin/zsh' }

$env:EDITOR = 'nvim'
$env:DENO_INSTALL = "$HOME/.deno"
$env:PNPM_HOME = "$HOME/.local/share/pnpm"

if (Test-Path -LiteralPath '/opt/homebrew') {
    $env:HOMEBREW_PREFIX = '/opt/homebrew'
    $env:HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
    $env:HOMEBREW_REPOSITORY = '/opt/homebrew'
}

# -------------------------
# PSReadLine: vi キーバインドと履歴補完
# -------------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Vi
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -HistoryNoDuplicates
}

# -------------------------
# Alias: Git
# PowerShell の Set-Alias は引数を持てないため、引数付きは関数で定義する
# -------------------------
function gs { git status --short --branch @args }
function gb { git branch @args }
function ga { git add @args }
function gaa { git add --all @args }
function gci { git commit @args }
function gcim { git commit -m @args }
function gd { git diff @args }
function gdc { git diff --cached @args }
function gco { git checkout @args }
function gre { git reset @args }
function gst { git stash @args }
function gstp { git stash pop @args }
function gp { git push @args }
function gpf { git push --force-with-lease @args }
function gpu { git push --set-upstream @args }
function gP { git pull --autostash @args }

# -------------------------
# Alias: Shell Basics / Docker
# -------------------------
function ll { ls -al @args }
function cls { Clear-Host }
function d { docker @args }
function dc { docker compose @args }
function b { brew @args }

# -------------------------
# Editor
# -------------------------
function n { nvim @args }
function nn { $env:NVIM_APPNAME = 'nvim-kawaii'; try { nvim @args } finally { $env:NVIM_APPNAME = $null } }
function n2 { $env:NVIM_APPNAME = 'nvim-sub'; try { nvim @args } finally { $env:NVIM_APPNAME = $null } }
function n5 { $env:NVIM_APPNAME = 'nvim-wagomu'; try { nvim @args } finally { $env:NVIM_APPNAME = $null } }

# -------------------------
# Project Navigation
# -------------------------
function p {
    $dir = (ghq list -p | fzf)
    if ($dir) { Set-Location -LiteralPath $dir.Trim() }
}
function gg { ghq get @args }

# -------------------------
# Prompt: cwd と git ブランチだけの軽量プロンプト
# -------------------------
function prompt {
    $cwd = $PWD.Path.Replace($HOME, '~')
    $branch = $null
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
    }

    Write-Host $cwd -NoNewline -ForegroundColor Blue
    if ($branch) {
        Write-Host " ($branch)" -NoNewline -ForegroundColor Magenta
    }
    return "`nPS> "
}
