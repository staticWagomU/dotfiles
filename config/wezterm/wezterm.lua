local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
config.font_size = 14.0
-- config.font = wezterm.font("JetBrains Mono")
config.font = wezterm.font("HackGen Console NF")
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.color_scheme = "iceberg-dark"
config.use_ime = false
config.disable_default_key_bindings = true
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true
config.keys = {
	-- paste from the clipboard
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	-- paste from the primary selection
	{ key = "V", mods = "CTRL", action = act.PasteFrom("PrimarySelection") },
	-- vim key binding
	{ key = "h", mods = "ALT", action = act.SendKey({ key = "LeftArrow" }) },
	{ key = "j", mods = "ALT", action = act.SendKey({ key = "DownArrow" }) },
	{ key = "k", mods = "ALT", action = act.SendKey({ key = "UpArrow" }) },
	{ key = "l", mods = "ALT", action = act.SendKey({ key = "RightArrow" }) },
}

return config
