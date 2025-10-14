local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()


wezterm.on('toggle-opacity', function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.9
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)
config.line_height = 1.3
config.font_size = 14.0
config.font = wezterm.font_with_fallback({ "HackGen Console NF" })
config.front_end = "WebGpu"
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.color_scheme = "iceberg-dark"
config.disable_default_key_bindings = false
config.window_background_opacity = 1
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.warn_about_missing_glyphs = false
config.adjust_window_size_when_changing_font_size = false
config.show_new_tab_button_in_tab_bar = false
config.use_ime = false
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

config.keys = {
	{ key = 'q',   mods = 'CTRL',       action = wezterm.action { SendString = '\x11' } },

	{ key = "C",   mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
	{ key = "V",   mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },

	{ key = "P",   mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
	{ key = "T",   mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "X",   mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = '!',   mods = "SHIFT|CTRL", action = wezterm.action.PaneSelect },
	{ key = '"',   mods = "SHIFT|CTRL", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = '#',   mods = "SHIFT|CTRL", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	{ key = "Tab", mods = "CTRL",       action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },

	{ key = "'",   mods = "SHIFT|CTRL", action = wezterm.action.EmitEvent 'toggle-opacity' },

	{ key = "(",   mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
	{ key = ")",   mods = "SHIFT|CTRL", action = act.IncreaseFontSize },

	{ key = "H",   mods = "SHIFT|CTRL", action = act.AdjustPaneSize { 'Left', 5 } },
	{ key = "J",   mods = "SHIFT|CTRL", action = act.AdjustPaneSize { 'Down', 5 } },
	{ key = "K",   mods = "SHIFT|CTRL", action = act.AdjustPaneSize { 'Up', 5 } },
	{ key = "L",   mods = "SHIFT|CTRL", action = act.AdjustPaneSize { 'Right', 5 } },

	{ key = "Enter", mods = "SHIFT",    action = wezterm.action { SendString = "\x1b\r" } },
}
config.window_padding = {
	left = "5px",
	right = 0,
	top = "5px",
	bottom = 0,
}
config.launch_menu = {
	{
		label = "WSL Ubuntu",
		domain = {
			DomainName = "WSL:Ubuntu"
		},
	},
	{
		label = "local",
		domain = {
			DomainName = "cmd.exe"
		},
	},
	{
		label = "MiniPc",
		args = { "ssh", "minipc-xubuntu.tail01a12.ts.net" }
	},
}
return config
