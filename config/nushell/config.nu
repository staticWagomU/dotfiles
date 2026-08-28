# WezTerm から起動する nushell の対話設定。
# env.nu より後に評価されるので、PATH はここでは組み立て済み。

$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.completions.case_sensitive = false
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true

# direnv: プロンプト表示前に .envrc の内容を取り込む。
# nushell には direnv hook がないため、公式ドキュメントの pre_prompt 方式を使う。
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt
    | append {||
        if (which direnv | is-empty) { return }
        direnv export json | from json | default {} | load-env
    }
)

# -------------------------
# Alias: Shell Basics
# -------------------------
alias cls = clear
alias ll = ls -al

# -------------------------
# Alias: Git
# -------------------------
alias gs = git status --short --branch
alias gb = git branch
alias ga = git add
alias gaa = git add --all
alias gci = git commit
alias gcim = git commit -m
alias gd = git diff
alias gdc = git diff --cached
alias gco = git checkout
alias gre = git reset
alias gst = git stash
alias gstp = git stash pop
alias gp = git push
alias gpf = git push --force-with-lease
alias gpu = git push --set-upstream
alias gP = git pull --autostash

# -------------------------
# Alias: Docker / Brew
# -------------------------
alias d = docker
alias dc = docker compose
alias b = brew

# -------------------------
# Editor
# -------------------------
alias v = vim
alias vi = vim
alias n = nvim

# nushell の alias は環境変数の前置きを書けないため def で包む
def --wrapped nn [...args] { with-env { NVIM_APPNAME: "nvim-kawaii" } { nvim ...$args } }
def --wrapped n2 [...args] { with-env { NVIM_APPNAME: "nvim-sub" } { nvim ...$args } }
def --wrapped n3 [...args] { with-env { NVIM_APPNAME: "nvim-darkpowered" } { nvim ...$args } }
def --wrapped n4 [...args] { with-env { NVIM_APPNAME: "nvim-tmp" } { nvim ...$args } }
def --wrapped n5 [...args] { with-env { NVIM_APPNAME: "nvim-wagomu" } { nvim ...$args } }

# -------------------------
# Project Navigation
# -------------------------
def --env p [] {
    let dir = (ghq list -p | fzf)
    if ($dir | is-not-empty) { cd ($dir | str trim) }
}
alias gg = ghq get
