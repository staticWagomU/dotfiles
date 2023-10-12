require("utils").make_abbrev({
  { from = "gb",   to = "GinBranch" },
  { from = "gc",   to = "Gin commit" },
  { from = "gco.", to = "Gin checkout ." },
  { from = "gd",   to = "GinDiff" },
  { from = "gds",  to = "GinDiff --cached" },
  { from = "gdss", to = "GinDiff stash@{}<Left>" },
  { from = "gin",  to = "Gin" },
  { from = "git",  to = "Gin" },
  { from = "gl",   to = "GinLog --graph --oneline" },
  { from = "gll",  to = "GinLog --graph" },
  { from = "gp",   to = "Gin push" },
  { from = "gpp",  to = "Gin pull" },
  { from = "grh",  to = "Gin reset --heard" },
  { from = "grs",  to = "Gin reset --soft" },
  { from = "gs",   to = "GinStatus" },
  { from = "gsc",  to = "Gin switch -C " },
  { from = "gsh",  to = "Gin show" },
  { from = "gsl",  to = "Gin stash list" },
  { from = "gss",  to = "Gin stash " },
})

require("utils").make_abbrev({
  { prepose = "Gin commit",        from = "a",  to = "--amend" },
  { prepose = "Gin reset --heard", from = "h",  to = "HEAD" },
  { prepose = "Gin reset --soft",  from = "h",  to = "HEAD" },
  { prepose = "Gin reset --soft",  from = "hh", to = "HEAD^" },
})

vim.g["gin_diff_default_args"] = { "++processor=delta" }

return {
  {
    "lambdalisue/gin.vim",
    dependencies = { "vim-denops/denops.vim" },
    config = function()
      local keymap = vim.keymap.set
      keymap("n", "<C-g><C-s>", "<Cmd>GinStatus<CR>", {})
      keymap("n", "<C-g><C-l>", "<Cmd>GinLog --graph<CR>", {})
      keymap("n", "<C-g><C-p>", "<Cmd>Gin push<CR>", {})
      keymap("n", "<C-g><C-h>", "<Cmd>Gin commit<CR>i", {})
    end,
  },
}

