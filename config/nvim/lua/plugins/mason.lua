return {
  "williamboman/mason.nvim",
  event = "BufReadPre",
  config = function()
    require("mason").setup({})
  end,
}
