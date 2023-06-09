require("utils").make_abbrev({
  { from = "git", to = "Gin" },
  { from = "gin", to = "Gin" },
  { from = "gs", to = "GinStatus" },
  { from = "gb", to = "GinBranch" },
  { from = "gp", to = "Gin push" },
  { from = "gsh", to = "Gin show" },
  { from = "gl", to = "GinLog --graph" },
  { from = "glo", to = "GinLog --graph --oneline" },
  { from = "gc", to = "Gin commit" },
  { prepose = "Gin commit", from = "a", to = "--amend" },
})

return {
  {
    "lambdalisue/gin.vim",
    dependencies = { "vim-denops/denops.vim" },
  },
}
