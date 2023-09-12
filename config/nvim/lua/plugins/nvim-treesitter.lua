return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  branch = "main",
  opts = {
    highlight = {
      enable = true,
    },
  },
  context_commentstring = {
    enable = true,
  },
}
