local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ============================================================
-- Appearance
-- ============================================================
config.line_height = 1.3
config.font_size = 14.0
config.font = wezterm.font_with_fallback({ "HackGen Console NF" })
config.font_rules = {
  {
    intensity = "Normal",
    italic = true,
    font = wezterm.font("HackGen Console NF", { weight = "Regular", style = "Normal" }),
  },
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font("HackGen Console NF", { weight = "Bold", style = "Normal" }),
  },
  {
    intensity = "Half",
    italic = true,
    font = wezterm.font("HackGen Console NF", { weight = "DemiLight", style = "Normal" }),
  },
}
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
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.window_padding = {
  left = "5px",
  right = 0,
  top = "5px",
  bottom = 0,
}
config.default_workspace = "default"

-- ============================================================
-- Leader Key: Ctrl+B (timeout 2s)
-- ============================================================
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

-- ============================================================
-- Helper Functions
-- ============================================================

-- Toggle opacity
wezterm.on("toggle-opacity", function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.9
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

-- Workspace toggle: remember previous workspace
local previous_workspace = "default"

local function toggle_workspace(target_workspace)
  return wezterm.action_callback(function(window, pane)
    local current = window:active_workspace()
    if current == target_workspace then
      window:perform_action(act.SwitchToWorkspace({ name = previous_workspace }), pane)
    else
      previous_workspace = current
      window:perform_action(act.SwitchToWorkspace({ name = target_workspace }), pane)
    end
  end)
end

-- Profile selector: generic factory for AWS/GCP/Cloudflare
local function create_profile_selector(title, get_profiles_fn, on_select_fn)
  return wezterm.action_callback(function(window, pane)
    local profiles = get_profiles_fn()
    if #profiles == 0 then
      window:set_right_status("No profiles found")
      wezterm.time.call_after(3, function()
        window:set_right_status("")
      end)
      return
    end
    local choices = {}
    for _, p in ipairs(profiles) do
      table.insert(choices, { label = p })
    end
    window:perform_action(
      act.InputSelector({
        title = title,
        choices = choices,
        fuzzy = true,
        action = wezterm.action_callback(function(inner_window, inner_pane, _, label)
          if label then
            on_select_fn(inner_window, inner_pane, label)
          end
        end),
      }),
      pane
    )
  end)
end

local function get_aws_profiles()
  local handle = io.popen("aws configure list-profiles 2>/dev/null")
  if not handle then
    return {}
  end
  local result = handle:read("*a")
  handle:close()
  local profiles = {}
  for line in result:gmatch("[^\r\n]+") do
    if line ~= "" then
      table.insert(profiles, line)
    end
  end
  return profiles
end

local function get_gcp_configs()
  local handle = io.popen("gcloud config configurations list --format='value(name)' 2>/dev/null")
  if not handle then
    return {}
  end
  local result = handle:read("*a")
  handle:close()
  local configs = {}
  for line in result:gmatch("[^\r\n]+") do
    if line ~= "" then
      table.insert(configs, line)
    end
  end
  return configs
end

-- Cloudflare accounts: reads ~/.config/cloudflare/accounts
-- Format: one "name=account_id" per line (lines starting with # are ignored)
local function get_cloudflare_accounts()
  local path = os.getenv("HOME") .. "/.config/cloudflare/accounts"
  local f = io.open(path, "r")
  if not f then
    return {}
  end
  local accounts = {}
  for line in f:lines() do
    if line ~= "" and not line:match("^#") then
      local name = line:match("^([^=]+)")
      if name then
        table.insert(accounts, name)
      end
    end
  end
  f:close()
  return accounts
end

local function get_cloudflare_account_id(name)
  local path = os.getenv("HOME") .. "/.config/cloudflare/accounts"
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  for line in f:lines() do
    local n, id = line:match("^([^=]+)=(.+)")
    if n == name then
      f:close()
      return id
    end
  end
  f:close()
  return nil
end

-- Overlay pane: split bottom, zoom to full
local function spawn_overlay_pane(command)
  return wezterm.action_callback(function(window, pane)
    local new_pane = pane:split({
      direction = "Bottom",
      size = 1.0,
      args = { os.getenv("SHELL"), "-lc", command },
    })
    window:perform_action(act.TogglePaneZoomState, new_pane)
  end)
end

-- ============================================================
-- Keys
-- ============================================================
config.keys = {
  -- Ctrl+Q passthrough
  { key = "q", mods = "CTRL", action = act.SendString("\x11") },

  -- Copy / Paste
  { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },

  -- Tab
  { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
  { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
  { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
  { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
  { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
  { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
  { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
  { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
  { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
  { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
  { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },

  -- Pane
  { key = "!", mods = "SHIFT|CTRL", action = act.PaneSelect },
  { key = '"', mods = "SHIFT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "#", mods = "SHIFT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "r", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

  -- Pane resize
  { key = "H", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "SHIFT|CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- Font size
  { key = "+", mods = "SUPER", action = act.IncreaseFontSize },
  { key = "-", mods = "SUPER", action = act.DecreaseFontSize },
  { key = "0", mods = "SUPER", action = act.ResetFontSize },
  { key = "(", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
  { key = ")", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },

  -- Opacity toggle
  { key = "'", mods = "SHIFT|CTRL", action = act.EmitEvent("toggle-opacity") },

  -- Shift+Enter: newline (for Claude Code multi-line input)
  { key = "Enter", mods = "SHIFT", action = act.SendString("\n") },

  -- ScrollToPrompt: jump between shell prompts
  { key = "[", mods = "ALT", action = act.ScrollToPrompt(-1) },
  { key = "]", mods = "ALT", action = act.ScrollToPrompt(1) },

  -- QuickSelect: highlight & pick patterns from screen
  { key = " ", mods = "SUPER", action = act.QuickSelect },

  -- Copy mode (vim-style terminal navigation)
  {
    key = "X",
    mods = "CTRL",
    action = act.Multiple({
      act.ActivateCopyMode,
      act.CopyMode("ClearPattern"),
      act.CopyMode("ClearSelectionMode"),
      act.CopyMode("MoveToViewportMiddle"),
    }),
  },

  -- Search
  {
    key = "f",
    mods = "SUPER",
    action = act.Multiple({
      act.Search("CurrentSelectionOrEmptyString"),
      act.CopyMode("ClearPattern"),
      act.CopyMode("ClearSelectionMode"),
    }),
  },

  -- Leader+Z: copy last command and its output to clipboard
  {
    key = "z",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(act.ActivateCopyMode, pane)
      window:perform_action(act.CopyMode({ MoveBackwardZoneOfType = "Input" }), pane)
      window:perform_action(act.CopyMode({ SetSelectionMode = "Cell" }), pane)
      window:perform_action(act.CopyMode({ MoveForwardZoneOfType = "Prompt" }), pane)
      window:perform_action(act.CopyMode("MoveUp"), pane)
      window:perform_action(act.CopyMode("MoveToEndOfLineContent"), pane)
      window:perform_action(
        act.Multiple({
          { CopyTo = "ClipboardAndPrimarySelection" },
          { Multiple = { "ScrollToBottom", { CopyMode = "Close" } } },
        }),
        pane
      )
      window:set_right_status("Copied!")
      wezterm.time.call_after(3, function()
        window:set_right_status("")
      end)
    end),
  },

  -- Workspace: scratch toggle (Ctrl+Shift+Alt+S)
  { key = "s", mods = "CTRL|SHIFT|ALT", action = toggle_workspace("scratch") },

  -- Workspace: fuzzy select (Ctrl+Shift+Alt+W)
  { key = "w", mods = "CTRL|SHIFT|ALT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

  -- Workspace: create new (Ctrl+Shift+Alt+N)
  {
    key = "n",
    mods = "CTRL|SHIFT|ALT",
    action = act.PromptInputLine({
      description = "New workspace name:",
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= "" then
          window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
  },

  -- Profile: AWS (Leader+A)
  {
    key = "a",
    mods = "LEADER",
    action = create_profile_selector("AWS Profile", get_aws_profiles, function(window, pane, label)
      window:perform_action(act.SendString("export AWS_PROFILE=" .. label .. "\n"), pane)
      window:set_right_status("AWS: " .. label)
      wezterm.time.call_after(3, function()
        window:set_right_status("")
      end)
    end),
  },

  -- Profile: GCP (Leader+G)
  {
    key = "g",
    mods = "LEADER",
    action = create_profile_selector("GCP Configuration", get_gcp_configs, function(window, pane, label)
      window:perform_action(act.SendString("gcloud config configurations activate " .. label .. "\n"), pane)
      window:set_right_status("GCP: " .. label)
      wezterm.time.call_after(3, function()
        window:set_right_status("")
      end)
    end),
  },

  -- Profile: Cloudflare (Leader+C)
  {
    key = "c",
    mods = "LEADER",
    action = create_profile_selector("Cloudflare Account", get_cloudflare_accounts, function(window, pane, label)
      local account_id = get_cloudflare_account_id(label)
      if account_id then
        window:perform_action(act.SendString("export CLOUDFLARE_ACCOUNT_ID=" .. account_id .. "\n"), pane)
        window:set_right_status("CF: " .. label)
      else
        window:set_right_status("CF: ID not found")
      end
      wezterm.time.call_after(3, function()
        window:set_right_status("")
      end)
    end),
  },

  -- Debug
  { key = "l", mods = "SUPER", action = act.ShowDebugOverlay },
  { key = "r", mods = "SUPER", action = act.ReloadConfiguration },
}

-- ============================================================
-- Key Tables
-- ============================================================
config.key_tables = {
  copy_mode = {
    -- Exit
    { key = "c", mods = "CTRL", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
    { key = "q", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },
    { key = "Escape", mods = "NONE", action = act.Multiple({ "ScrollToBottom", { CopyMode = "Close" } }) },

    -- Vim navigation
    { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
    { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
    { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
    { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
    { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
    { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
    { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },

    -- Jump to char (vim f/t/F/T)
    { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
    { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },

    -- Page scroll
    { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
    { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },

    -- Selection
    { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
    { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
    { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },

    -- Copy (stay in copy mode for consecutive copies)
    { key = "y", mods = "NONE", action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" } }) },

    -- Search from copy mode
    { key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
    { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },

    -- ScrollToPrompt in copy mode
    { key = "[", mods = "ALT", action = act.ScrollToPrompt(-1) },
    { key = "]", mods = "ALT", action = act.ScrollToPrompt(1) },

    -- Semantic zone navigation (jump between command inputs)
    { key = "]", mods = "NONE", action = act.CopyMode({ MoveForwardZoneOfType = "Input" }) },
    { key = "[", mods = "NONE", action = act.CopyMode({ MoveBackwardZoneOfType = "Input" }) },
    { key = "z", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "SemanticZone" }) },
  },

  search_mode = {
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
    {
      key = "n",
      mods = "CTRL",
      action = act.Multiple({ act.CopyMode("NextMatch"), act.ActivateCopyMode }),
    },
    {
      key = "p",
      mods = "CTRL",
      action = act.Multiple({ act.CopyMode("PriorMatch"), act.ActivateCopyMode }),
    },
    { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
    { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
    { key = "X", mods = "CTRL", action = act.ActivateCopyMode },
  },
}

-- ============================================================
-- QuickSelect Patterns
-- ============================================================
config.quick_select_patterns = {
  -- URL
  "\\bhttps?://[\\w\\-._~:/?#@!$&'()*+,;=%]+",
  -- File paths (after whitespace/delimiter, or at line start)
  "(?<=[\\s:=(\"'`])(?:~|/)[/\\w\\-.@~]+",
  "(?m)^(?:~|/)[/\\w\\-.@~]+(?=\\s*$)",
  -- Git commit hash (7-40 chars)
  "\\b[0-9a-f]{7,40}\\b",
  -- IP address
  "\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b",
  -- UUID
  "\\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\\b",
  -- AWS ARN
  "\\barn:[\\w\\-]+:[\\w\\-]+:[\\w\\-]*:[0-9]*:[\\w\\-/:=.]+",
}

-- ============================================================
-- Command Palette
-- ============================================================
wezterm.on("augment-command-palette", function(_, _)
  return {
    {
      brief = "GitHub: Browse repository",
      icon = "md_github",
      action = spawn_overlay_pane("gh browse"),
    },
    {
      brief = "GitHub: Pull Requests (web)",
      icon = "md_github",
      action = spawn_overlay_pane("gh pr list --web"),
    },
    {
      brief = "GitHub: Issues (web)",
      icon = "md_github",
      action = spawn_overlay_pane("gh issue list --web"),
    },
    {
      brief = "GitHub: PR status",
      icon = "md_github",
      action = spawn_overlay_pane("gh pr status"),
    },
  }
end)

-- ============================================================
-- Launch Menu
-- ============================================================
config.launch_menu = {
  {
    label = "Nucbox3",
    args = { "ssh", "nucbox3.tail01a12.ts.net" },
  },
  {
    label = "Desktop-1",
    args = { "ssh", "desktop-1.tail01a12.ts.net" },
  },
}

-- ============================================================
-- Plugin
-- ============================================================
local pane_manager = wezterm.plugin.require("file://" .. wezterm.config_dir .. "/pane-manager.wezterm")
pane_manager.apply_to_config(config)


return config
