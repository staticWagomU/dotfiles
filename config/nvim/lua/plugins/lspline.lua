return {
  "Maan2003/lsp_lines.nvim",
  opts = {},
  config = function()
    -- Disable virtual_text since it's redundant due to lsp_lines.
    vim.diagnostic.config({
      virtual_text = false,
    })

    vim.keymap.set(
      "n",
      "<Leader>l",
      require("lsp_lines").toggle,
      { desc = "Toggle lsp_lines", silent = true }
    )
  end
}
