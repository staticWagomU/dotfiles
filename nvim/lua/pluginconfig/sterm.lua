require("sterm").setup({
  split_direction = "right"
})

local keymap = vim.keymap.set
keymap({ 't', 'n' }, "<F5>", require("sterm").toggle, { silent = true })
