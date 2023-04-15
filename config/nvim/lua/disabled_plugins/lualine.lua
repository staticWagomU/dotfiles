local M = {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
}

function M.config()
  local vim = vim
  local lualine = require('lualine')

  local macchiato = require("catppuccin.palettes").get_palette "macchiato"


  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand('%:p:h')
      local gitdir = vim.fn.finddir('.git', filepath .. ';')
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
  }

  -- Config
  local config = {
    options = {
      -- Disable sections and component separators
      component_separators = '',
      section_separators = '',
      theme = {
        normal = { c = { fg = macchiato.text, bg = macchiato.mantle } },
        inactive = { c = { fg = macchiato.text, bg = macchiato.crust } },
      },
      disabled_filetypes = { 'Trouble', 'alpha', 'lspsagaoutline', 'lir', 'toggleterm' },
      globalstatus = true,
    },
    sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      -- These will be filled later
      lualine_c = {},
      lualine_x = {},
    },
    inactive_sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }

  -- Inserts a component in lualine_c at left section
  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  -- Inserts a component in lualine_x ot right section
  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  local function setModeColor(mode)
    local cmd = vim.api.nvim_command

    local mode_color = {
      n = macchiato.green,
      i = macchiato.red,
      v = macchiato.blue,
      [''] = macchiato.blue,
      V = macchiato.blue,
      c = macchiato.yellow,
      no = macchiato.green,
      s = macchiato.mauve,
      S = macchiato.mauve,
      [''] = macchiato.mauve,
      ic = macchiato.blue,
      R = macchiato.lavender,
      Rv = macchiato.lavender,
      cv = macchiato.red,
      ce = macchiato.red,
      r = macchiato.yellow,
      rm = macchiato.yellow,
      ['r?'] = macchiato.yellow,
      ['!'] = macchiato.red,
      t = macchiato.red,
    }
    cmd('hi Mode guibg=' .. mode_color[mode] .. ' guifg=' .. macchiato.mantle .. ' gui=bold')
    cmd('hi ModeSeparator  guibg=' .. macchiato.mantle .. ' guifg=' .. mode_color[mode])
  end

  local function getmode()
    local left_separator = ''
    local right_separator = ''
    local mode = vim.fn.mode()
    local modeTable = {
      n = 'N',
      i = 'I',
      v = 'v',
      [''] = 'V',
      V = 'V',
      c = 'C',
      no = 'N·Operator Pending',
      s = 'Select',
      S = 'S·Line',
      [''] = 'S·Block',
      ic = 'I',
      ix = 'I',
      R = 'Replace',
      Rv = 'V.Replace',
      cv = 'Vim Ex',
      ce = 'Ex',
      r = 'Prompt',
      rm = 'More',
      ['r?'] = 'Confirm',
      ['!'] = 'Shell',
      t = 'T',
    }
    setModeColor(mode)
    return '%#ModeSeparator#'
    .. left_separator
    .. '%#Mode# '
    .. modeTable[mode]
    .. ' %#ModeSeparator#'
    .. right_separator
  end

  ins_left {
    function()
      return getmode()
    end
  }

  ins_left {
    'branch',
    icon = '',
    color = { fg = macchiato.lavender },
  }


  ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
      color_error = { fg = macchiato.red },
      color_warn = { fg = macchiato.lavender },
      color_info = { fg = macchiato.yellow },
    },
  }

  ins_left {
    'diff',
    -- Is it me or the symbol for modified us really weird
    symbols = { added = ' ', modified = '柳 ', removed = ' ' },
    diff_color = {
      added = { fg = macchiato.green },
      modified = { fg = macchiato.mauve },
      removed = { fg = macchiato.red },
    },
    cond = conditions.hide_in_width,
  }

  -- Insert mid section. You can make any number of sections in neovim :)
  -- for lualine it's any number greater then 2
  ins_left {
    function()
      return '%='
    end,
  }

  ins_left {
    -- Lsp server name .
    function()
      local msg = 'No Active Lsp'
      local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
      return msg
    end,
    icon = ' LSP:',
    color = { fg = macchiato.text, gui = 'bold' },
  }

  ins_right       {
    require("lazy.status").updates,
    cond = require("lazy.status").has_updates,
    color = { fg = macchiato.blue},
  }

  ins_right { 'filetype' }

  ins_right { 'location' }

  ins_right { 'progress', color = { fg = macchiato.text } }

  ins_right {
    -- filesize component
    'filesize',
    cond = conditions.buffer_not_empty,
  }

  -- Add components to right sections
  ins_right {
    'o:encoding', -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = macchiato.green, gui = 'bold' },
  }

  ins_right {
    'fileformat',
    fmt = string.upper,
    icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
    color = { fg = macchiato.green, gui = 'bold' },
  }

  -- Now don't forget to initialize lualine
  lualine.setup(config)
  -- lualine.setup()
end

return M
