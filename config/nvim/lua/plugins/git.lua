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
  },
}
