vim.keymap.set("n", "<C-G><C-n>", "<cmd>Neogit<CR>", { noremap = true, silent = true })
return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  cmd = { "Neogit" },
  keys = "<C-G><C-G>",
  config = function()
    local neogit = require("neogit")
    neogit.setup({})
  end,
}

