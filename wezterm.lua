local wezterm = require("wezterm")
return {
        default_prog = {os.getenv("LOCALAPPDATA") .. "\\Microsoft\\WindowsApps\\Microsoft.PowerShell_8wekyb3d8bbwe\\pwsh.exe")},
        color_scheme = "Dracula",
        font_size = 10.0,
        font = wezterm.font "JetBrains Mono",
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
        color_scheme = "iceberg-dark"
}
