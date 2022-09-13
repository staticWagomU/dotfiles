require("sterm").setup({
  split_direction = "right"
})

vim.keymap.set({ 't', 'n' }, "<F5>", require("sterm").toggle, { silent = true })
