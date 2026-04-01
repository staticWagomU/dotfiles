-- pane-manager.wezterm
-- A unified pane management plugin for WezTerm
-- https://github.com/user/pane-manager.wezterm

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local wezterm_cli = wezterm.executable_dir .. "/wezterm"

-- ============================================================
-- Helpers
-- ============================================================

--- Collect all panes across all tabs in the current window
---@param window any
---@param exclude_pane_id number|nil  pane id to exclude from the list
---@return table[]  { id, tab_index, tab_title, title, cwd }
local function collect_all_panes(window, exclude_pane_id)
  local result = {}
  for _, tab_info in ipairs(window:mux_window():tabs_with_info()) do
    for _, pane_info in ipairs(tab_info.tab:panes_with_info()) do
      local p = pane_info.pane
      local pid = p:pane_id()
      if pid ~= exclude_pane_id then
        local cwd = p:get_current_working_dir()
        local dir = ""
        if cwd then
          dir = cwd.file_path or tostring(cwd)
          -- shorten home directory
          local home = wezterm.home_dir
          if home and dir:sub(1, #home) == home then
            dir = "~" .. dir:sub(#home + 1)
          end
        end
        table.insert(result, {
          id = pid,
          tab_index = tab_info.index,
          tab_title = tab_info.tab:get_title(),
          title = p:get_title(),
          cwd = dir,
        })
      end
    end
  end
  return result
end

--- Build an InputSelector choice entry for a pane
---@param p table  pane info from collect_all_panes
---@param opts table|nil  { highlight = bool }
---@return table  { id, label }
local function make_pane_choice(p, opts)
  opts = opts or {}
  local color = opts.highlight and "Green" or "Aqua"
  local suffix = opts.highlight and "  ★ current" or ""

  return {
    id = tostring(p.id),
    label = wezterm.format({
      { Foreground = { AnsiColor = color } },
      { Text = string.format("[Tab %d] ", p.tab_index + 1) },
      { Foreground = { AnsiColor = "White" } },
      { Text = string.format("Pane %d: %s", p.id, p.title) },
      { Foreground = { AnsiColor = "Silver" } },
      { Text = p.cwd ~= "" and ("  " .. p.cwd) or "" },
      { Foreground = { AnsiColor = "Green" } },
      { Text = suffix },
    }),
  }
end

--- Build a direction selector (horizontal / vertical)
---@param window any
---@param pane any
---@param callback fun(direction: string)  "horizontal" | "vertical"
local function ask_split_direction(window, pane, callback)
  window:perform_action(
    act.InputSelector({
      title = "Split direction",
      choices = {
        {
          id = "horizontal",
          label = wezterm.format({
            { Foreground = { AnsiColor = "Aqua" } },
            { Text = "⬅ ➡  Horizontal (side by side)" },
          }),
        },
        {
          id = "vertical",
          label = wezterm.format({
            { Foreground = { AnsiColor = "Lime" } },
            { Text = "⬆ ⬇  Vertical (top / bottom)" },
          }),
        },
      },
      action = wezterm.action_callback(function(w, p, id, _)
        if not id then return end
        callback(id)
      end),
    }),
    pane
  )
end

--- Execute wezterm CLI split-pane with --move-pane-id
---@param target_pane_id number|string  destination pane to split
---@param move_pane_id number|string    pane to move
---@param direction string              "horizontal" | "vertical"
local function cli_split_move(target_pane_id, move_pane_id, direction)
  local args = {
    wezterm_cli, "cli", "split-pane",
    "--pane-id", tostring(target_pane_id),
    "--move-pane-id", tostring(move_pane_id),
  }
  if direction == "horizontal" then
    table.insert(args, "--horizontal")
  end
  -- vertical is the default (no flag needed)
  wezterm.background_child_process(args)
end

--- Show a toast notification
---@param window any
---@param msg string
local function toast(window, msg)
  window:toast_notification("Pane Manager", msg, nil, 3000)
end

-- ============================================================
-- Actions
-- ============================================================

--- Detach current pane to a new tab in the same window
local function action_detach_to_tab(window, pane)
  local tab, _ = pane:move_to_new_tab()
  if tab then
    toast(window, "Pane moved to new tab")
  end
end

--- Detach current pane to a new window
local function action_detach_to_window(window, pane)
  local tab, _ = pane:move_to_new_window()
  if tab then
    toast(window, "Pane moved to new window")
  end
end

--- Grab a pane from another tab into the current tab (split)
local function action_grab_pane(window, pane)
  local current_id = pane:pane_id()
  local panes = collect_all_panes(window, current_id)

  if #panes == 0 then
    toast(window, "No other panes available")
    return
  end

  local choices = {}
  for _, p in ipairs(panes) do
    table.insert(choices, make_pane_choice(p))
  end

  window:perform_action(
    act.InputSelector({
      title = "Grab which pane into current tab?",
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Select pane to grab: ",
      action = wezterm.action_callback(function(w, p, id, _)
        if not id then return end
        ask_split_direction(w, p, function(direction)
          cli_split_move(current_id, id, direction)
        end)
      end),
    }),
    pane
  )
end

--- Send current pane to another tab (split beside a chosen pane)
local function action_send_pane(window, pane)
  local current_id = pane:pane_id()
  local panes = collect_all_panes(window, current_id)

  if #panes == 0 then
    toast(window, "No other panes to send to")
    return
  end

  local choices = {}
  for _, p in ipairs(panes) do
    table.insert(choices, make_pane_choice(p))
  end

  window:perform_action(
    act.InputSelector({
      title = "Send current pane to...",
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Select destination: ",
      action = wezterm.action_callback(function(w, p, target_id, _)
        if not target_id then return end
        ask_split_direction(w, p, function(direction)
          cli_split_move(target_id, current_id, direction)
        end)
      end),
    }),
    pane
  )
end

--- Swap panes within the same tab (delegate to PaneSelect)
local function action_swap_pane(window, pane)
  window:perform_action(
    act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
    pane
  )
end

--- Rotate panes clockwise
local function action_rotate_cw(window, pane)
  window:perform_action(act.RotatePanes("Clockwise"), pane)
end

--- Rotate panes counter-clockwise
local function action_rotate_ccw(window, pane)
  window:perform_action(act.RotatePanes("CounterClockwise"), pane)
end

--- Move current pane to a new tab within an existing window
--- (Creates a new tab in the chosen window's context)
local function action_move_to_new_tab_in_window(window, pane)
  -- For now just creates a new tab in the same window
  -- wezterm cli move-pane-to-new-tab --pane-id X
  local current_id = pane:pane_id()
  wezterm.background_child_process({
    wezterm_cli, "cli", "move-pane-to-new-tab",
    "--pane-id", tostring(current_id),
  })
  toast(window, "Pane moved to a new tab")
end

-- ============================================================
-- Command Palette
-- ============================================================

--- Define the command palette entries
---@return table[]
local function build_command_list()
  return {
    {
      id = "grab_pane",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Lime" } },
        { Text = "📥  Grab pane into current tab (split)" },
      }),
      desc = "Pull a pane from another tab into a split here",
    },
    {
      id = "send_pane",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Aqua" } },
        { Text = "📤  Send current pane to another tab (split)" },
      }),
      desc = "Move current pane beside a pane in another tab",
    },
    {
      id = "swap",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Yellow" } },
        { Text = "🔄  Swap with another pane (same tab)" },
      }),
      desc = "Swap position with another pane in this tab",
    },
    {
      id = "rotate_cw",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "🔃  Rotate panes clockwise" },
      }),
      desc = "Rotate all pane contents clockwise",
    },
    {
      id = "rotate_ccw",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "🔃  Rotate panes counter-clockwise" },
      }),
      desc = "Rotate all pane contents counter-clockwise",
    },
    {
      id = "detach_tab",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Silver" } },
        { Text = "📑  Detach pane to new tab" },
      }),
      desc = "Move pane into its own tab in the same window",
    },
    {
      id = "detach_window",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Silver" } },
        { Text = "📦  Detach pane to new window" },
      }),
      desc = "Move pane into a brand new window",
    },
    {
      id = "move_new_tab",
      label = wezterm.format({
        { Foreground = { AnsiColor = "Silver" } },
        { Text = "📑  Move pane to new tab (via CLI)" },
      }),
      desc = "Move pane into a new tab using wezterm CLI",
    },
  }
end

--- Dispatch a chosen action
local function dispatch(window, pane, action_id)
  local actions = {
    grab_pane = action_grab_pane,
    send_pane = action_send_pane,
    swap = action_swap_pane,
    rotate_cw = action_rotate_cw,
    rotate_ccw = action_rotate_ccw,
    detach_tab = action_detach_to_tab,
    detach_window = action_detach_to_window,
    move_new_tab = action_move_to_new_tab_in_window,
  }
  local fn = actions[action_id]
  if fn then
    fn(window, pane)
  end
end

--- Open the command palette
local function open_pane_manager(window, pane)
  local commands = build_command_list()
  local choices = {}
  for _, cmd in ipairs(commands) do
    table.insert(choices, { id = cmd.id, label = cmd.label })
  end

  window:perform_action(
    act.InputSelector({
      title = "🔧 Pane Manager",
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Action: ",
      action = wezterm.action_callback(function(w, p, id, _)
        if not id then return end
        dispatch(w, p, id)
      end),
    }),
    pane
  )
end

-- ============================================================
-- Plugin entry point
-- ============================================================

--- Apply the plugin to the config
---@param config table  wezterm config builder
---@param opts table|nil  { key, mods, direct_keys }
function M.apply_to_config(config, opts)
  opts = opts or {}

  local palette_key = opts.key or "p"
  local palette_mods = opts.mods or "LEADER"

  config.keys = config.keys or {}

  -- Main: command palette
  table.insert(config.keys, {
    key = palette_key,
    mods = palette_mods,
    action = wezterm.action_callback(open_pane_manager),
  })

  -- Optional direct keybindings
  if opts.direct_keys ~= false then
    local dk = opts.direct_keys or {}

    -- Grab pane: LEADER + g
    table.insert(config.keys, {
      key = dk.grab_key or "g",
      mods = dk.grab_mods or "LEADER",
      action = wezterm.action_callback(action_grab_pane),
    })

    -- Send pane: LEADER + m
    table.insert(config.keys, {
      key = dk.send_key or "m",
      mods = dk.send_mods or "LEADER",
      action = wezterm.action_callback(action_send_pane),
    })

    -- Swap pane (same tab): LEADER + s
    table.insert(config.keys, {
      key = dk.swap_key or "s",
      mods = dk.swap_mods or "LEADER",
      action = wezterm.action_callback(action_swap_pane),
    })

    -- Rotate CW: LEADER + r
    table.insert(config.keys, {
      key = dk.rotate_cw_key or "r",
      mods = dk.rotate_cw_mods or "LEADER",
      action = wezterm.action_callback(action_rotate_cw),
    })

    -- Rotate CCW: LEADER + R (shift)
    table.insert(config.keys, {
      key = dk.rotate_ccw_key or "R",
      mods = dk.rotate_ccw_mods or "LEADER|SHIFT",
      action = wezterm.action_callback(action_rotate_ccw),
    })

    -- Detach to tab: LEADER + !
    table.insert(config.keys, {
      key = dk.detach_tab_key or "!",
      mods = dk.detach_tab_mods or "LEADER|SHIFT",
      action = wezterm.action_callback(action_detach_to_tab),
    })

    -- Detach to window: LEADER + @
    table.insert(config.keys, {
      key = dk.detach_window_key or "@",
      mods = dk.detach_window_mods or "LEADER|SHIFT",
      action = wezterm.action_callback(action_detach_to_window),
    })
  end
end

-- Also export individual actions for advanced users
M.open_pane_manager = open_pane_manager
M.action_grab_pane = action_grab_pane
M.action_send_pane = action_send_pane
M.action_swap_pane = action_swap_pane
M.action_rotate_cw = action_rotate_cw
M.action_rotate_ccw = action_rotate_ccw
M.action_detach_to_tab = action_detach_to_tab
M.action_detach_to_window = action_detach_to_window

return M

