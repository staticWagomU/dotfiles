require("Comment").setup({})
local keymap = vim.keymap.set

keymap("n", "<C-_>", "<Cmd>lua require('Comment.api').toggle.linewise.current()<CR>", {})
keymap("v", "<C-_>", "gc", {})
