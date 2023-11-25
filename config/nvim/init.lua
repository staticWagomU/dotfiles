vim.g["denops_server_addr"] = "127.0.0.1:32123"
vim.loader.enable()
require("setup")
vim.cmd.colorscheme("nightfox")
require("dpp_vim")
require("options")
require("keymaps")

