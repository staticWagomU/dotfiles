local wezterm = require("wezterm")
return {
        if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
                default_prog = {os.getenv("LOCALAPPDATA") .. "\\Microsoft\\WindowsApps\\Microsoft.PowerShell_8wekyb3d8bbwe\\pwsh.exe")},
        end
        color_scheme = "Dracula",
        font_size = 10.0,
        font = wezterm.font "JetBrains Mono",
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
        color_scheme = "iceberg-dark"
}
