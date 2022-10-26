vim.cmd [[packadd packer.nvim]]

return require("packer").startup({ function(use)
  use { "wbthomason/packer.nvim", opt = true }

  use { "lewis6991/impatient.nvim" }

  use { "nvim-lua/plenary.nvim" }
  use { "vim-denops/denops.vim", }
  use { "MunifTanjim/nui.nvim" }
  use { "kyazdani42/nvim-web-devicons" }

  use {
    "williamboman/mason.nvim",
    requires = {
      { "neovim/nvim-lspconfig", after = "mason.nvim" },
      { "williamboman/mason-lspconfig.nvim", after = "mason.nvim" }
    },
    config = 'require("pluginconfig.mason")',
    event = { "VimEnter" },
  }

  use {
    "neovim/nvim-lspconfig",
    config = 'require("pluginconfig.nvim-lspconfig")',
  }

  use { "williamboman/mason-lspconfig.nvim" }

  use {
    "mweisshaupt1988/neobeans.vim",
    as = "neobeans",
    config = 'require("pluginconfig.neobeans")',
  }

  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.0",
    requires = {
      { "nvim-lua/plenary.nvim", after = "telescope.nvim" },
    },
    config = 'require("pluginconfig.telescope")',
    event = { "VimEnter" }
  }

  use { "nvim-telescope/telescope-ui-select.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-symbols.nvim", after = "telescope.nvim" }
  use { "crispgm/telescope-heading.nvim", after = "telescope.nvim" }
  use { "LinArcX/telescope-changes.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-rg.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-smart-history.nvim", after = "telescope.nvim" }
  use { "nvim-telescope/telescope-github.nvim", after = "telescope.nvim" }

  use {
    "nvim-treesitter/nvim-treesitter",
    config = 'require("pluginconfig.nvim-treesitter")',
    event = { "VimEnter" }
  }

  use {
    "hrsh7th/nvim-cmp",
    config = 'require("pluginconfig.nvim-cmp")',
    event = { "InsertEnter", "CmdlineEnter" },
  }

  use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
  use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
  use { "hrsh7th/cmp-path", after = "nvim-cmp" }
  use { "hrsh7th/cmp-cmdline", after = "nvim-cmp" }
  use { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" }
  use { "hrsh7th/cmp-calc", after = "nvim-cmp" }
  use { "f3fora/cmp-spell", after = "nvim-cmp" }
  use { "yutkat/cmp-mocword", after = "nvim-cmp" }
  use {
    "onsails/lspkind.nvim",
    config = 'require("pluginconfig.lspkind")',
  }
  use { "petertriho/cmp-git", after = "nvim-cmp" }
  use { "ray-x/lsp_signature.nvim" }

  use {
    "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    config = 'require("pluginconfig.LuaSnip")',
    event = { "InsertEnter" },
  }

  use {
    "nvim-lualine/lualine.nvim",
    config = 'require("pluginconfig.lualine")',
    event = { "BufRead", "BufNewFile" },
  }

  use {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = 'require("pluginconfig.lspsaga")',
    event = { "VimEnter" }
  }

  use { "rcarriga/nvim-notify" }

  use {
    "lewis6991/gitsigns.nvim",
    config = 'require("pluginconfig.gitsigns")',
    event = { "VimEnter" }
  }

  use {
    "windwp/nvim-autopairs",
    config = 'require("nvim-autopairs").setup({})',
    event = { "VimEnter" }
  }

  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = 'require("pluginconfig.nvim-navic")',
    event = { "VimEnter" }
  }

  use {
    "anuvyklack/pretty-fold.nvim",
    config = 'require("pretty-fold").setup({})',
    event = { "VimEnter" }
  }

  use {
    "petertriho/nvim-scrollbar",
    config = 'require("pluginconfig.nvim-scrollbar")',
    event = { "VimEnter" }
  }

  use {
    "goolord/alpha-nvim",
    config = 'require("pluginconfig.alpha-nvim")'
  }

  use {
    "akinsho/toggleterm.nvim",
    config = 'require("pluginconfig.toggleterm")',
    event = { "VimEnter" }
  }

  use {
    "numToStr/Comment.nvim",
    config = 'require("pluginconfig.comment")',
    event = { "VimEnter" }
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = 'require("pluginconfig.trouble")',
    event = { "VimEnter" }
  }

  use {
    "yuki-yano/fuzzy-motion.vim",
    after = { "denops.vim" },
    config = 'require("pluginconfig.fuzzy-motion")',
    event = { "BufEnter" },
  }

  use { "mattn/vim-sonictemplate" }

  use {
    "simeji/winresizer",
    event = { "VimEnter" }
  }

  use {
    "folke/lsp-colors.nvim",
    config = 'require("pluginconfig.lsp-colors")',
    event = { "VimEnter" }
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = 'require("pluginconfig.null-ls")',
    event = { "VimEnter" }
  }


  use {
    "TimUntersberger/neogit",
    requires = {
      { "nvim-lua/plenary.nvim", after = "neogit" },
    },
    config = 'require("pluginconfig.neogit")',
    cmd = { "Neogit" }
  }

  use {
    "sindrets/diffview.nvim",
    requires = {
      { "nvim-lua/plenary.nvim", after = "diffview.nvim" },
    },
    config = 'require("pluginconfig.diffview")',
    cmd = {
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewRefresh",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewFileHistory",
    },
  }

  use {
    "j-hui/fidget.nvim",
    config = 'require "fidget".setup {}'
  }

  use { "vim-jp/vimdoc-ja" }

  use {
    "mattn/emmet-vim",
    event = { "VimEnter" }
  }

  use {
    "mattn/vim-goimports",
    ft = "go"
  }

  use {
    "skanehira/denops-translate.vim",
    config = 'require("pluginconfig.denops-translate")',
    event = { "VimEnter" }
  }

  use { "kevinhwang91/promise-async" }
  use { "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" }
  use {
    "Maan2003/lsp_lines.nvim",
    config = 'require("pluginconfig.lsp_lines")',
  }

  use {
    "folke/which-key.nvim",
    config = 'require("pluginconfig.which-key")',
    event = { "VimEnter" }
  }

  use {
    "kylechui/nvim-surround",
    config = 'require("nvim-surround").setup({})',
    event = { "VimEnter" }
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = 'require("pluginconfig.indent-blankline")',
  }

  use {
    "haya14busa/vim-edgemotion",
    config = 'require("pluginconfig.vim-edgemotion")',
    event = { "VimEnter" }
  }

  use {
    "levouh/tint.nvim",
    config = 'require("pluginconfig.tint")',
    event = { "VimEnter" }
  }

  use {
    "tamago324/lir.nvim",
    requires = { "nvim-web-devicons" },
    config = 'require("pluginconfig.lir")',
    event = { "VimEnter" }
  }

  use {
    "tamago324/lir-git-status.nvim",
    requires = { "lir.nvim" }
  }

  use {
    "nathom/filetype.nvim",
    config = 'require("pluginconfig.filetype")',
  }

  use {
    "gen740/SmoothCursor.nvim",
    config = 'require("pluginconfig.SmoothCursor")'
  }

  use({
    "folke/noice.nvim",
    event = { "VimEnter" },
    config = 'require("pluginconfig.noice")',
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  })

  vim.cmd [[colorscheme neobeans]]

end,
  config = {
    enable = true,
    threshold = 1
  } })
