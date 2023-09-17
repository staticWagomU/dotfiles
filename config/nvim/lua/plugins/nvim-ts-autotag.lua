return {
  "windwp/nvim-ts-autotag",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "html", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue", "astro" },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
