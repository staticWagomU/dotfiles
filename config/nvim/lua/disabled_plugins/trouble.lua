return {
  "folke/trouble.nvim",
  event = "BufReadPre",
  config = function()
    require("trouble").setup()
end
}
