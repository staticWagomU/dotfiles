local g = {}
local c = {}
g, _ = vim.fn['iceberg#palette#dark#create']()

-- Lua
require("lsp-colors").setup({
  Error = g.gui.red,
  Warning = g.gui.yellow,
  Information = g.gui.green,
  Hint = g.gui.orange,
})
