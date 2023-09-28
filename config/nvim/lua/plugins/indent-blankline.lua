vim.g["indent_blankline_use_treesitter"] = true
vim.g["indent_blankline_enabled"] = false

require("utils").make_abbrev({
  { from = "ib", to = "IBLToggle" },
})

return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    require("ibl").setup({
      indent = {
        char = "│",
      }
    })
  end,
}
