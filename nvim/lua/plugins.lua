vim.cmd [[packadd packer.nvim]]

return require("packer").startup({ function(use)
  use { "wbthomason/packer.nvim" }

  use { "lewis6991/impatient.nvim" }

  use { "nvim-lua/plenary.nvim" }
  use {
    "vim-denops/denops.vim",
    event = "CursorHold",
  }
  use { "MunifTanjim/nui.nvim" }
  use { "kyazdani42/nvim-web-devicons" }

  use {
    "williamboman/mason.nvim",
    requires = {
      { "neovim/nvim-lspconfig", after = "mason.nvim" },
      { "williamboman/mason-lspconfig.nvim", after = "mason.nvim" }
    },
    config = 'require("pluginconfig.mason")',
    event = "VimEnter",
  }

  use {
    "neovim/nvim-lspconfig",
    config = 'require("pluginconfig.nvim-lspconfig")',
  }

  use { "williamboman/mason-lspconfig.nvim" }

  use {
    "mweisshaupt1988/neobeans.vim",
    as = "neobeans",
    config = function()
      require("neobeans").setup({
        nvim_tree = { contrast = true }, -- or use contrast = false to not apply contrast
        light_mode = false, -- the default is the dark theme, set to true to enable light theme
      })
    end
  }

  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.0",
    requires = {
      { "nvim-lua/plenary.nvim", after = "telescope.nvim" },
    },
    config = function()
      require("pluginconfig/telescope")
    end,
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
    config = function()
      require("pluginconfig/nvim-treesitter")
    end,
    event = { "VimEnter" }
  }

  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require("pluginconfig/nvim-cmp")
    end,
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
    config = function()
      require("pluginconfig/lspkind")
    end
  }
  use { "petertriho/cmp-git", after = "nvim-cmp" }
  use { "ray-x/lsp_signature.nvim" }

  use {
    "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    config = function()
      require("pluginconfig/LuaSnip")
    end,
    event = "InsertEnter",
  }

  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("pluginconfig/lualine")
    end,
    event = { "BufRead", "BufNewFile" },
  }

  use {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("pluginconfig/lspsaga")
    end,
    event = { "VimEnter" }
  }

  use { "rcarriga/nvim-notify" }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("pluginconfig/gitsigns")
    end,
    event = { "VimEnter" }
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
    event = { "VimEnter" }
  }

  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
      ---@diagnostic disable-next-line: different-requires
      require("pluginconfig/nvim-navic")
    end,
    event = { "VimEnter" }
  }

  use {
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup()
    end,
    event = { "VimEnter" }
  }

  use {
    "petertriho/nvim-scrollbar",
    config = function()
      require("pluginconfig/nvim-scrollbar")
    end,
    event = { "VimEnter" }
  }

  use {
    "goolord/alpha-nvim",
    config = function()
      require("pluginconfig/alpha-nvim")
    end
  }

  use {
    "akinsho/toggleterm.nvim",
    config = function()
      require("pluginconfig/toggleterm")
    end,
    event = { "VimEnter" }
  }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("pluginconfig/comment")
    end,
    event = { "VimEnter" }
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("pluginconfig/trouble")
    end,
    event = { "VimEnter" }
  }

  use {
    "yuki-yano/fuzzy-motion.vim",
    after = { "denops.vim" },
    config = function()
      require("pluginconfig/fuzzy-motion")
    end,
    event = "BufEnter",
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
    config = function()
      require("nvim-surround").setup({})
    end,
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
    "fgheng/winbar.nvim",
    config = 'require("pluginconfig.winbar")',
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
    config = function()
      require("pluginconfig/filetype")
    end
  }

  use {
    "gen740/SmoothCursor.nvim",
    config = function()
      require("pluginconfig/SmoothCursor")
    end
  }

  use({
    "folke/noice.nvim",
    event = "VimEnter",
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
