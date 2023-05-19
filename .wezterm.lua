local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}
config.keys = {
  -- paste from the clipboard
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  -- paste from the primary selection
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },
}

return config
