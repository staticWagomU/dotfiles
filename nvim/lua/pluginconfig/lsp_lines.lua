require("lsp_lines").setup()
vim.api.nvim_create_user_command('ToggleLspLines', function(_)
  vim.g.is_virtual_lines = require('lsp_lines').toggle()
end, { nargs = 0 })
