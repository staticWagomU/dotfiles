require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  shade_filetypes = { 'none' },
  -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
  direction = 'horizontal',
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  start_in_insert = true,
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    -- like `size`, width and height can be a number or function which is passed the current terminal
    -- width = <value>,
    -- height = <value>,
    -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    border = 'rounded',
    winblend = 3
  },
  -- autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
  autochdir = true,
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  -- on_open = fun(t: Terminal), -- function to run when the terminal opens
  -- on_close = fun(t: Terminal), -- function to run when the terminal closes
  -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
  -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
  -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
  hide_numbers = true, -- hide the number column in toggleterm buffers
  highlights = {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    -- Normal = {
    --   guibg = "<VALUE-HERE>",
    -- },
    NormalFloat = {
      link = 'Normal'
    },
    -- FloatBorder = {
    --   guifg = "<VALUE-HERE>",
    --   guibg = "<VALUE-HERE>",
    -- },
  },

  shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
  -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  winbar = {
    enabled = false,
    -- name_formatter = function(term) --  term: Terminal
    --   return term.name
    -- end
  },
})

local float_handler = function(term)
  if vim.fn.mapcheck('jk', 't') ~= '' then
    vim.api.nvim_buf_del_keymap(term.bufnr, 't', 'jk')
    vim.api.nvim_buf_del_keymap(term.bufnr, 't', '<esc>')
  end
end

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({
  cmd = 'lazygit',
  dir = 'git_dir',
  hidden = true,
  direction = 'float',
  on_open = float_handler,
})

local toggleLazegit = function()
  lazygit:toggle()
end
vim.api.nvim_create_user_command('Lazygit', toggleLazegit, {})
