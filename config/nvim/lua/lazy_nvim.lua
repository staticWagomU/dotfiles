-- bootstrap from github
local vim = vim
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins",{
  -- defaults = { lazy = true },
  checker = { enabled = true },
  diff = {
    cmd = "terminal_git",
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disable_plugins = {
        "gzip",
        "zip",
        "zipPlugin",
        "tar",
        "tarPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "netrwPlugin",
      },
    },
    ui = {
      border = 'rounded',
    }
  },
})

vim.keymap.set("n", "<leader>li", "<cmd>Lazy install<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lu", "<cmd>Lazy update<CR>", { noremap = true, silent = true })
