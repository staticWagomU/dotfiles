return {
  "ray-x/go.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  event = {"CmdlineEnter"},
  ft = {"go", "gomod"},
  config = function()
    require("go").setup()
  end,
  build = [[:lua require("go.install").update_all_sync()]]
}
