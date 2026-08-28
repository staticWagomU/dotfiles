# WezTerm から起動する nushell の環境設定。
#
# GUI から起動された端末は launchd の最小 PATH しか継承せず、nushell は
# /etc/profile も ~/.profile も読まない。そのため config/fish/config.fish が
# fish_add_path で組み立てているのと同じ探索パスをここで作り直す。

let home = $nu.home-dir
let user = ($home | path basename)

# 先頭ほど優先度が高い（fish 側の最終的な PATH 順に合わせている）
let preferred_paths = [
    $"($home)/.volta/bin"
    $"($home)/.local/share/pnpm"
    $"($home)/.bun/bin"
    $"($home)/.deno/bin"
    $"($home)/.npm-global/bin"
    $"($home)/go/bin"
    $"($home)/.local/bin"
    $"($home)/bin"
    $"($home)/dotfiles/scripts"
    $"/etc/profiles/per-user/($user)/bin"
    $"($home)/.nix-profile/bin"
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
]

# PATH は通常 ENV_CONVERSIONS でリスト化されるが、変換前の文字列で渡ることもある
let inherited_raw = ($env.PATH? | default [])
let inherited = (
    if (($inherited_raw | describe) | str starts-with "string") {
        $inherited_raw | split row (char esep)
    } else {
        $inherited_raw
    }
)

$env.PATH = (
    $preferred_paths
    | append $inherited
    | uniq
    | where {|p| ($p | is-not-empty) and ($p | path exists) }
)

# $SHELL は「対話シェル」ではなく「他のツールがコマンド実行を委譲する先」として
# 使われる (fzf, git, claude などが $SHELL -c ... を呼ぶ)。nu/pwsh は POSIX 互換の
# 引数を取らないため、既存の挙動どおり fish を指したままにする。
let fish_path = $"/etc/profiles/per-user/($user)/bin/fish"
$env.SHELL = (if ($fish_path | path exists) { $fish_path } else { "/bin/zsh" })

$env.EDITOR = "nvim"
$env.DENO_INSTALL = $"($home)/.deno"
$env.PNPM_HOME = $"($home)/.local/share/pnpm"
$env.WEZTERM_CONFIG_FILE = $"($home)/.config/wezterm/wezterm.lua"

# Homebrew の shellenv 相当（brew --prefix を呼ばずに済ませる）
if ("/opt/homebrew" | path exists) {
    $env.HOMEBREW_PREFIX = "/opt/homebrew"
    $env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
    $env.HOMEBREW_REPOSITORY = "/opt/homebrew"
}
