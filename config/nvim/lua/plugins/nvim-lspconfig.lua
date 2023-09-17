return {
  "neovim/nvim-lspconfig",
  lazy = false,
  event = { "BufReadPre" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    for type, icon in pairs({ Error = "🔴", Warn = "🟡", Hint = "🟢", Info = "🔵" }) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}
