return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = { "<leader>e", "<leader>E" },
  config = function()
    require("oil").setup({
    })
    vim.keymap.set("n", "<leader>e",
    function ()
      vim.cmd"Oil ."
      vim.defer_fn(function()
        vim.cmd.FuzzyMotion()
      end, 300)
    end,
    { noremap=true, silent=true })
    vim.keymap.set("n", "<leader>E", "<cmd>Oil %:p:h<cr>", { noremap=true, silent=true })
  end,
  event = { "BufReadPre", "BufNewFile" },
}
