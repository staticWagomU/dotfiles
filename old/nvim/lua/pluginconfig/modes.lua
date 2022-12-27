local colors = require("neobeans.core").get_dark_colors()

require('modes').setup({
  colors = {
    copy = colors.yellow,
    delete = colors.red,
    insert = colors.blue,
    visual = colors.purple,
  },

  -- Set opacity for cursorline and number background
  line_opacity = 0.15,

  -- Enable cursor highlights
  set_cursor = true,

  -- Enable cursorline initially, and disable cursorline for inactive windows
  -- or ignored filetypes
  set_cursorline = true,

  -- Enable line number highlights to match cursorline
  set_number = true,

  -- Disable modes highlights in specified filetypes
  -- Please PR commonly ignored filetypes
  ignore_filetypes = { 'NvimTree', 'TelescopePrompt', 'alpha', 'Trouble' }
})
