return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      return {
        signcolumn = true,
        numhl = true,
        attach_to_untracked = true,
        on_attach = function()
        end,
      }
    end
  },
  {
    "lambdalisue/gin.vim",
    dependencies = { "vim-denops/denops.vim" },
    config = function ()
      require("utils").make_abbrev({
        { from = "git", to = "Gin" },
        { from = "gin", to = "Gin" },
        { from = "gs", to = "GinStatus" },
        { from = "gp", to = "Gin push" },
        { from = "gsh", to = "Gin show" },
        { from = "gl", to = "GinLog --graph" },
        { from = "glo", to = "GinLog --graph --oneline" },
        { from = "gc", to = "Gin commit" },
        { prepose = "Gin commit", from = "a", to = "--amend" },
      })
    end,
  },
}
