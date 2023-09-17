---@diagnostic disable-next-line: unused-local
local enabled_vtsls = true

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  },
  opts = function()
    local o = { opts = {} }
  end,
  config = function(_, opts)
  end,
}

