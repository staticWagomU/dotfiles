return {
  "nyngwang/NeoTerm.lua",
  config = function ()
    require("neo-term").setup {
      exclude_filetypes = { "oil" },
    }
    vim.keymap.set("n", "<M-d>", function () vim.cmd("NeoTermToggle") end)
    vim.keymap.set("t", "<M-d>", function () vim.cmd("NeoTermEnterNormal") end)
  end
}
