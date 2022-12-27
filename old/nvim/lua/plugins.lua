vim.cmd("packadd packer.nvim")
return require("packer").startup(function(use)
  use { "wbthomason/packer.nvim", opt = true }

  use { "lewis6991/impatient.nvim" }

  use { "nvim-lua/plenary.nvim" }
  use { "vim-denops/denops.vim" }
  use { "MunifTanjim/nui.nvim" }
  use { "kyazdani42/nvim-web-devicons" }

  use {
    "williamboman/mason.nvim",
    config = "require('mason').setup({})",
    event = { "VimEnter" },
  }

  use {
    "neovim/nvim-lspconfig",
    config = "require('pluginconfig.nvim-lspconfig')",
    event = { "VimEnter" },
  }

  use {
    "williamboman/mason-lspconfig.nvim",
    after = { "mason.nvim", "nvim-lspconfig", "cmp-nvim-lsp" },
    config = "require('pluginconfig.mason-lspconfig')"
  }

  use { "mweisshaupt1988/neobeans.vim" }

  use { "nvim-telescope/telescope.nvim" }
  use { "nvim-telescope/telescope-ui-select.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-symbols.nvim", after = "telescope.nvim" }
  use { "crispgm/telescope-heading.nvim", after = "telescope.nvim" }
  use { "LinArcX/telescope-changes.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-rg.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-smart-history.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-github.nvim", after = "telescope.nvim" }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = "require('pluginconfig.nvim-treesitter')"
  }

  use { "hrsh7th/nvim-cmp",
    requires = {
      { "L3MON4D3/LuaSnip", opt = true, event = "VimEnter" },
      { "windwp/nvim-autopairs", opt = true, event = "VimEnter" },
    },
    after = { "LuaSnip", "nvim-autopairs" },
    config = "require('pluginconfig.nvim-cmp')"
  }
  use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
  use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
  use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
  use { "hrsh7th/cmp-path", after = "nvim-cmp" }
  use { "hrsh7th/cmp-cmdline", after = "nvim-cmp" }
  use { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" }
  use { "hrsh7th/cmp-calc", after = "nvim-cmp" }
  use { "f3fora/cmp-spell", after = "nvim-cmp" }
  use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
  use { "yutkat/cmp-mocword", after = "nvim-cmp" }
  use { "petertriho/cmp-git", after = "nvim-cmp" }
  use { "ray-x/lsp_signature.nvim", after = "nvim-cmp" }
  use { "onsails/lspkind.nvim" }

  use { "L3MON4D3/LuaSnip" }

  use {
    "nvim-lualine/lualine.nvim",
    config = "require('pluginconfig.lualine')"
  }

  use {
    "glepnir/lspsaga.nvim",
    after = "mason.nvim",
    config = "require('pluginconfig.lspsaga')"
  }

  use { "rcarriga/nvim-notify" }

  use {
    "lewis6991/gitsigns.nvim",
    config = "require('pluginconfig.gitsigns')"
  }

  use {
    "windwp/nvim-autopairs",
    config = "require('nvim-autopairs').setup({})"
  }

  use { "SmiteshP/nvim-navic" }

  use { "anuvyklack/pretty-fold.nvim" }

  use { "petertriho/nvim-scrollbar" }

  use {
    "goolord/alpha-nvim",
    config = "require('pluginconfig.alpha-nvim')"
  }

  use {
    "akinsho/toggleterm.nvim",
    config = "require('pluginconfig.toggleterm')"
  }

  use {
    "numToStr/Comment.nvim",
    config = "require('pluginconfig.Comment')"
  }

  use { "folke/trouble.nvim" }

  use {
    "yuki-yano/fuzzy-motion.vim",
    config = "require('pluginconfig.fuzzy-motion')"
  }

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

  use {
    "tamago324/lir.nvim",
    config = "require('pluginconfig.lir')"
  }

  use { "tamago324/lir-git-status.nvim" }

  use { "nathom/filetype.nvim" }

  use { "gen740/SmoothCursor.nvim" }

  use {
    "folke/noice.nvim",
    config = "require('pluginconfig.noice')"
  }

  use { "catppuccin/nvim" }

end)
