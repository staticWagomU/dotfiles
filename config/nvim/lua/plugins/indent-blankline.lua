vim.g["indent_blankline_use_treesitter"] = true
vim.g["indent_blankline_enabled"] = false

require("utils").make_abbrev({
  { from = "ib", to = "IndentBlanklineToggle" },
})

return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    show_end_of_line = true,
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
  },
}
