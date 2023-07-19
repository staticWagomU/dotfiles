return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    require("utils").on_attach(function()
      vim.keymap.set("n", "<Space>lt", "<cmd>TroubleToggle<cr>", {noremap = true, silent = true})
    end)
  end,
  event = "LspAttach",
}
