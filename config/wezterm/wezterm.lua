local wezterm = require("wezterm")
local act = wezterm.action

-- local config = {}
local config = wezterm.config_builder()
config.font_size = 14.0
config.font = wezterm.font_with_fallback({ "HackGen Console NF" })
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.color_scheme = "iceberg-dark"
config.disable_default_key_bindings = true
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.warn_about_missing_glyphs = false
config.adjust_window_size_when_changing_font_size = false
config.keys = {
    { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
    { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },

    { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "L", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "X", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
    { key = '"', mods = "SHIFT|CTRL", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

    { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },

}
config.window_padding = {
    left = "5px",
    right = 0,
    top = "5px",
    bottom = 0,
}
return config
