return {
  "glepnir/lspsaga.nvim",
  event = "LspAttach",
  opts = {
      symbol_in_winbar = {
        enable = false,
        show_file = false,
      },
  },
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter" }
  }
}
