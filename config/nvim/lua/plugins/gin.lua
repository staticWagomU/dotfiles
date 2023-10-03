require("utils").make_abbrev({
  { from = "git",  to = "Gin" },
  { from = "gin",  to = "Gin" },
  { from = "gs",   to = "GinStatus" },
  { from = "gb",   to = "GinBranch" },
  { from = "gp",   to = "Gin push" },
  { from = "gpp",  to = "Gin pull" },
  { from = "gsh",  to = "Gin show" },
  { from = "gll",  to = "GinLog --graph" },
  { from = "gl",   to = "GinLog --graph --oneline" },
  { from = "gc",   to = "Gin commit" },
  { from = "gd",   to = "GinDiff" },
  { from = "gds",  to = "GinDiff --cached" },
  { from = "gdss", to = "GinDiff stash@{}<Left>" },
  { from = "gss",  to = "Gin stash " },
  { from = "gsl",  to = "Gin stash list" },
  { from = "gsc",  to = "Gin switch -C " },
  { from = "grs",  to = "Gin reset --soft" },
  { from = "grh",  to = "Gin reset --heard" },
  { from = "gco.", to = "Gin checkout ." },
})

require("utils").make_abbrev({
  { prepose = "Gin commit",        from = "a",  to = "--amend" },
  { prepose = "Gin reset --soft",  from = "h",  to = "HEAD" },
  { prepose = "Gin reset --soft",  from = "hh", to = "HEAD^" },
  { prepose = "Gin reset --heard", from = "h",  to = "HEAD" },
})

vim.g["gin_diff_default_args"] = { "++processor=delta" }

return {
  {
    "lambdalisue/gin.vim",
    dependencies = { "vim-denops/denops.vim" },
  },
}
