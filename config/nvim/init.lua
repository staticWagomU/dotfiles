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

vim.cmd.colorscheme("nightfly")
