return {
  "nyngwang/NeoTerm.lua",
  keys = {"<M-d>"},
  config = function ()
    require("neo-term").setup {
      exclude_filetypes = { "oil" },
    }
    vim.keymap.set("n", "<M-d>", function () vim.cmd("NeoTermToggle") end)
    vim.keymap.set("t", "<M-d>", function () vim.cmd("NeoTermToggle") end)
  end
}
