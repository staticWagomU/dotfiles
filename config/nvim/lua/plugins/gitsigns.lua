return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signcolumn = true,
      numhl = true,
      attach_to_untracked = true,
      on_attach = function()
      end,
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "[g", "<cmd>Gitsigns prev_hunk<cr>", opts)
    vim.keymap.set("n", "]g", "<cmd>Gitsigns next_hunk<cr>", opts)
    vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", opts)
    vim.keymap.set("n", "<leader>gss", "<cmd>Gitsigns stage_hunk<cr>", opts)
    vim.keymap.set("n", "<leader>gss", "<cmd>Gitsigns undo_stage_hunk<cr>", opts)
  end,
}
