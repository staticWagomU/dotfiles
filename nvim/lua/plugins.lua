vim.cmd [[packadd packer.nvim]]

return require("packer").startup({ function(use)
  use { "wbthomason/packer.nvim" }

  use {
    "lewis6991/impatient.nvim",
    config = function()
      require('impatient')
      require('impatient').enable_profile()
    end
  }

  use { "nvim-lua/plenary.nvim" }
  use { "vim-denops/denops.vim" }
  use { "MunifTanjim/nui.nvim" }
  use { "kyazdani42/nvim-web-devicons" }

  use {
    "williamboman/mason.nvim",
    requires = {
      { "neovim/nvim-lspconfig", after = "mason.nvim" },
      { "williamboman/mason-lspconfig.nvim", after = "mason.nvim" }
    },
    config = function()
      require("pluginconfig/mason")
    end,
    event = "VimEnter",
  }

  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("pluginconfig/nvim-lspconfig")
    end
  }

  use { "williamboman/mason-lspconfig.nvim" }

  use {
    "cocopon/iceberg.vim",
    config = function()
      require("pluginconfig/iceberg")
    end,
    after = { "pgmnt.vim" }
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
    event = { "VimEnter" }
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

  use { "L3MON4D3/LuaSnip", after = "nvim-cmp" }

  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      { "cocopon/pgmnt.vim" },
    },
    config = function()
      require("pluginconfig/lualine")
    end,
    event = { "VimEnter" }
  }

  use { "cocopon/pgmnt.vim" }

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
    end
  }

  use { "mattn/vim-sonictemplate" }

  use {
    "simeji/winresizer",
    event = { "VimEnter" }
  }

  use {
    "folke/lsp-colors.nvim",
    config = function()
      require("pluginconfig/lsp-colors")
    end,
    event = { "VimEnter" }
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("pluginconfig/null-ls")
    end,
    event = { "VimEnter" }
  }


  use {
    "TimUntersberger/neogit",
    requires = {
      { "nvim-lua/plenary.nvim", after = "neogit" },
    },
    config = function()
      require("pluginconfig/neogit")
    end,
    cmd = { "Neogit" }
  }

  use {
    "sindrets/diffview.nvim",
    requires = {
      { "nvim-lua/plenary.nvim", after = "diffview.nvim" },
    },
    config = function()
      require("pluginconfig/diffview")
    end,
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
    config = function()
      require "fidget".setup {}
    end
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
    config = function()
      require("pluginconfig/denops-translate")
    end,
    event = { "VimEnter" }
  }

  use { "kevinhwang91/promise-async" }
  use { "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" }
  use {
    "Maan2003/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
    event = { "VimEnter" }
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("pluginconfig/which-key")
    end,
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
    config = function()
      require("pluginconfig/indent-blankline")
    end,
    event = { "VimEnter" }
  }

  use {
    "haya14busa/vim-edgemotion",
    config = function()
      require("pluginconfig/vim-edgemotion")
    end,
    event = { "VimEnter" }
  }

  use {
    "levouh/tint.nvim",
    config = function()
      require("pluginconfig/tint")
    end,
    event = { "VimEnter" }
  }

  use {
    "fgheng/winbar.nvim",
    config = function()
      require("pluginconfig/winbar")

    end,
    event = { "VimEnter" }
  }

  use {
    "tamago324/lir.nvim",
    requires = { "nvim-web-devicons" },
    config = function()
      require("pluginconfig/lir")
    end,
    event = { "VimEnter" }
  }

  use {
    "tamago324/lir-git-status.nvim",
    requires = { "lir.nvim" }
  }

  use {
    "nathom/filetype.nvim",
    config = function()
      -- In init.lua or filetype.nvim's config file
      require("filetype").setup({
        overrides = {
          extensions = {
            -- Set the filetype of *.pn files to potion
            pn = "potion",
          },
          literal = {
            -- Set the filetype of files named "MyBackupFile" to lua
            MyBackupFile = "lua",
          },
          complex = {
            -- Set the filetype of any full filename matching the regex to gitconfig
            [".*git/config"] = "gitconfig", -- Included in the plugin
          },

          -- The same as the ones above except the keys map to functions
          function_extensions = {
            ["cpp"] = function()
              vim.bo.filetype = "cpp"
              -- Remove annoying indent jumping
              vim.bo.cinoptions = vim.bo.cinoptions .. "L0"
            end,
            ["pdf"] = function()
              vim.bo.filetype = "pdf"
              -- Open in PDF viewer (Skim.app) automatically
              vim.fn.jobstart(
                "open -a skim " .. '"' .. vim.fn.expand("%") .. '"'
              )
            end,
          },
          function_literal = {
            Brewfile = function()
              vim.cmd("syntax off")
            end,
          },
          function_complex = {
            ["*.math_notes/%w+"] = function()
              vim.cmd("iabbrev $ $$")
            end,
          },

          shebang = {
            -- Set the filetype of files with a dash shebang to sh
            dash = "sh",
          },
        },
      })
    end
  }

end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    },
    enable = true,
    threshold = 1
  } })
