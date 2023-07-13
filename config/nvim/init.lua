vim.env.DOTVIM = vim.fn.expand("<sfile>:p:h")
require("options")
require("lazy_nvim")
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("mapping")
    require("command")
    require("abbrev")
  end,
})

DEFAULT_COLORSCHEME = "nightfly"
-- DEFAULT_COLORSCHEME = "citruszest"
-- INACTIVE_COLORSCHEME = "nordfox"
INACTIVE_COLORSCHEME = "citruszest"
vim.cmd.colorscheme(DEFAULT_COLORSCHEME)
