return {
  "rebelot/heirline.nvim",
  dependencies = {
    "bluz71/vim-nightfly-colors",
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("heirline").setup({
      statusline = require("plugins/heirline/statusline"),
      winbar = require("plugins/heirline/winbar"),
    })
  end,
  --event = { "WinNew", },
}
