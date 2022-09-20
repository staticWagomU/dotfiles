require("Comment").setup({})
local keymap = vim.keymap.set

keymap("n", "<C-_>", "<Cmd>lua require('Comment.api').toggle.linewise.current()<CR>", {})
keymap("i", "<C-_>", "<Esc>:<C-u>lua require('Comment.api').toggle.linewise.current()<CR>\"_cc", {})
keymap("v", "<C-_>", "gc", {})
