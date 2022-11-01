vim.cmd('packadd vim-jetpack')
return require("jetpack.packer").startup( function(use)
  use { "tani/vim-jetpack", opt = true }

  use { "lewis6991/impatient.nvim" }

  use { "nvim-lua/plenary.nvim" }
  use { "vim-denops/denops.vim" }
  use { "MunifTanjim/nui.nvim" }
  use { "kyazdani42/nvim-web-devicons" }

  use { "williamboman/mason.nvim" }

  use { "neovim/nvim-lspconfig" }

  use { "williamboman/mason-lspconfig.nvim" }

  use { "mweisshaupt1988/neobeans.vim"}

  use { "nvim-telescope/telescope.nvim" }
  use { "nvim-telescope/telescope-ui-select.nvim" }
  use { "nvim-telescope/telescope-symbols.nvim" }
  use { "crispgm/telescope-heading.nvim" }
  use { "LinArcX/telescope-changes.nvim" }
  use { "nvim-telescope/telescope-rg.nvim" }
  use { "nvim-telescope/telescope-smart-history.nvim" }
  use { "nvim-telescope/telescope-github.nvim" }

  use { "nvim-treesitter/nvim-treesitter" }

  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-cmdline" }
  use { "saadparwaiz1/cmp_luasnip" }
  use { "hrsh7th/cmp-nvim-lsp-signature-help" }
  use { "hrsh7th/cmp-nvim-lsp-document-symbol" }
  use { "hrsh7th/cmp-calc" }
  use { "f3fora/cmp-spell" }
  use { "yutkat/cmp-mocword" }
  use { "onsails/lspkind.nvim" }
  use { "petertriho/cmp-git" }
  use { "ray-x/lsp_signature.nvim" }

  use { "L3MON4D3/LuaSnip" }

  use { "nvim-lualine/lualine.nvim" }

  use { "glepnir/lspsaga.nvim" }

  use { "rcarriga/nvim-notify" }

  use { "lewis6991/gitsigns.nvim" }

  use { "windwp/nvim-autopairs" }

  use { "SmiteshP/nvim-navic" }

  use { "anuvyklack/pretty-fold.nvim" }

  use { "petertriho/nvim-scrollbar" }

  use { "goolord/alpha-nvim" }

  use { "akinsho/toggleterm.nvim" }

  use { "numToStr/Comment.nvim" }

  use { "folke/trouble.nvim" }

  use { "yuki-yano/fuzzy-motion.vim" }

  use { "mattn/vim-sonictemplate" }

  use { "simeji/winresizer" }

  use { "folke/lsp-colors.nvim" }

  use { "jose-elias-alvarez/null-ls.nvim" }

  use { "TimUntersberger/neogit" }

  use { "sindrets/diffview.nvim" }

  use { "vim-jp/vimdoc-ja" }

  use { "mattn/emmet-vim" }

  use {
    "mattn/vim-goimports",
    ft = "go"
  }

  use { "skanehira/denops-translate.vim" }

  use { "kevinhwang91/promise-async" }
  use { "kevinhwang91/nvim-ufo" }
  use { "Maan2003/lsp_lines.nvim" }

  use { "folke/which-key.nvim" }

  use { "kylechui/nvim-surround" }

  use { "lukas-reineke/indent-blankline.nvim" }

  use { "haya14busa/vim-edgemotion" }

  use { "levouh/tint.nvim" }

  use { "tamago324/lir.nvim" }
  use { "tamago324/lir-git-status.nvim" }

  use { "nathom/filetype.nvim" }

  use { "gen740/SmoothCursor.nvim" }

  use{ "folke/noice.nvim" }

end)
