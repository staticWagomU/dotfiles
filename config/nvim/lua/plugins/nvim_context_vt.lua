return {
  "andersevenrud/nvim_context_vt",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("nvim_context_vt").setup({
        prefix = "",
      })
  end,
}
