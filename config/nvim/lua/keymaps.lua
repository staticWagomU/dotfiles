local opts = { silent = true, noremap = true }
local keymap = vim.keymap.set

keymap({ "n" }, "<Leader>w", "<Cmd>w<Cr>", opts)

keymap({ "n" }, "<Leader>bn", "<Cmd>bnext<Cr>", opts)
keymap({ "n" }, "<Leader>bp", "<Cmd>bprevioues<Cr>", opts)
keymap({ "n" }, "<Leader>bd", "<Cmd>bdelete<Cr>", opts)

