return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
    })
    vim.keymap.set("n", "<leader>e", "<cmd>Oil .<cr>", { noremap=true, silent=true })
    vim.keymap.set("n", "<leader>E", "<cmd>Oil %:p:h<cr>", { noremap=true, silent=true })
  end
}
