return {
	{
		"catppuccin/nvim",
		lazy = false,
	},
  {
    "mweisshaupt1988/neobeans.vim",
    lazy = false,
    priority =  1000,
    config = function()
      require("neobeans").setup({
        nvim_tree = { contrast = true }, -- or use contrast = false to not apply contrast
        light_mode = false, -- the default is the dark theme, set to true to enable light theme
      })
      vim.cmd([[ colorscheme neobeans]])
    end,
  }
}
