return {
  "vidocqh/data-viewer.nvim",
  ft = {"csv", "tsv", "sqlite"},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kkharji/sqlite.lua",
  },
  opts = {
    autoDisplayWhenOpenFile = true,
  },
}
