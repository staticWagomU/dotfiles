return {
  "uga-rosa/ccc.nvim",
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    }
  },
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "CccPick", "CccConvert", "CccHightlighterToggle" },
}
