local wezterm = require("wezterm")
local opts = {
  font_size = 10.0,
  font = wezterm.font "JetBrains Mono",
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  color_scheme = "iceberg-dark"
}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  local pwsh_path = os.getenv("LOCALAPPDATA") .. [[\Microsoft\WindowsApps\Microsoft.PowerShell_8wekyb3d8bbwe\pwsh.exe]]
  opts["default_prog"] = { pwsh_path }
end

return opts
