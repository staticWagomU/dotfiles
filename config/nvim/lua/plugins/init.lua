return {

	{ "lewis6991/impatient.nvim" },
	-- base
	{ "nvim-lua/plenary.nvim" },
	{ "vim-denops/denops.vim" },
	{ "MunifTanjim/nui.nvim" },
	{ "kyazdani42/nvim-web-devicons" },
  { "jose-elias-alvarez/typescript.nvim" },
	{"anuvyklack/pretty-fold.nvim"},
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPre",
    config = function()
      require("scrollbar").setup({})
    end
  },
	{"akinsho/toggleterm.nvim"},
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
      require("Comment").setup({})
    end,
  },
	{
		"folke/trouble.nvim",
	},
  { 
		"mattn/vim-sonictemplate",
		cmd = "Template"
	},
	{ "simeji/winresizer" },
  {
    "folke/lsp-colors.nvim",
    event = "BufReadPost",
    config = function()
      local colors = require("neobeans.core").get_dark_colors()

      require("lsp-colors").setup({
        Error = colors.red,
        Warning = colors.yellow,
        Information = colors.green,
        Hint = colors.orange,
      })
    end
  },
  { "mattn/emmet-vim" },
	{
		"mattn/vim-goimports",
		ft = "go"
	},
	{ 
		"skanehira/denops-translate.vim",
		dependencies = { "vim-denops/denops.vim" },
	},
  {
    "Maan2003/lsp_lines.nvim",
    event = "BufReadPost",
    config = function()
      require("lsp_lines").setup()
      vim.api.nvim_create_user_command('ToggleLspLines', function(_)
        vim.g.is_virtual_lines = require('lsp_lines').toggle()
      end, { nargs = 0 })
    end
  },
	{ "folke/which-key.nvim" },
	{ "kylechui/nvim-surround" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "nathom/filetype.nvim" },
	{
    "gen740/SmoothCursor.nvim" ,
    event = "BufReadPre",
    config = function()
      require('smoothcursor').setup({})
    end
  },
}
