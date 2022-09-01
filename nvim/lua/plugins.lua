vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
	use {"wbthomason/packer.nvim"}

        use {"nvim-lua/plenary.nvim"}
        use {"vim-denops/denops.vim"}
        use { "MunifTanjim/nui.nvim"}

        use {
                "williamboman/mason.nvim",
                requires = {
                        {"neovim/nvim-lspconfig", after = "mason.nvim"},
                        {"williamboman/mason-lspconfig.nvim", after = "mason.nvim"}
                },
                config = function()
                        require("pluginconfig/mason")
                end
        }
        use {"neovim/nvim-lspconfig"}
        use {"williamboman/mason-lspconfig.nvim"}

	use {
                "cocopon/iceberg.vim",
                config = function()
                        require("pluginconfig/iceberg")
                end
        }

        use {
                "nvim-telescope/telescope.nvim", tag = "0.1.0",
                requires = { 
                        {"nvim-lua/plenary.nvim", after = "telescope.nvim"},
                        {"nvim-telescope/telescope-ui-select.nvim", after="telescope.nvim" },
                        {"nvim-telescope/telescope-symbols.nvim", after="telescope.nvim" },
                        {"crispgm/telescope-heading.nvim", after="telescope.nvim" },
                        {"LinArcX/telescope-changes.nvim", after="telescope.nvim" },
                        {"nvim-telescope/telescope-rg.nvim", after="telescope.nvim" },
                        {"nvim-telescope/telescope-smart-history.nvim", after="telescope.nvim" },
                        {"nvim-telescope/telescope-fzy-native.nvim"},
                        {"nvim-telescope/telescope-file-browser.nvim"},
                        {"kyazdani42/nvim-web-devicons", after="telescope.nvim" },
                        {"folke/trouble.nvim", after="telescope.nvim" }
                },
                config = function()
                        require("pluginconfig/telescope")
                end
        }
        use {
                "nvim-telescope/telescope-file-browser.nvim",
                requires="telescope.nvim",
                config = function()
                        require("telescope").load_extension("file_browser")
                end
        }

        use {
                "nvim-telescope/telescope-fzy-native.nvim",
                requires="telescope.nvim",
                config = function()
                        require("telescope").load_extension("fzy_native")
                end
        }

        use {
                "nvim-telescope/telescope-project.nvim",
                requires="telescope.nvim",
                config = function()
                        require'telescope'.load_extension('project')
                end
        }

        use {"nvim-telescope/telescope-github.nvim"}
        use {"nvim-telescope/telescope-ui-select.nvim"}
        use {"nvim-telescope/telescope-symbols.nvim"}
        use {"crispgm/telescope-heading.nvim"}
        use {"LinArcX/telescope-changes.nvim"}
        use {"nvim-telescope/telescope-rg.nvim"}
        use {"nvim-telescope/telescope-smart-history.nvim"}
        use {"kyazdani42/nvim-web-devicons"}

        use {
                "nvim-treesitter/nvim-treesitter",
                config = function()
                        require("pluginconfig/nvim-treesitter")
                end
        }

        use {
                "hrsh7th/nvim-cmp",
                requires = {
                        {"neovim/nvim-lspconfig", after="hrsh7th/nvim-cmp"},
                        {"hrsh7th/cmp-nvim-lsp", after="hrsh7th/nvim-cmp"},
                        {"hrsh7th/cmp-buffer", after="hrsh7th/nvim-cmp"},
                        {"hrsh7th/cmp-path", after="hrsh7th/nvim-cmp"},
                        {"hrsh7th/cmp-cmdline", after="hrsh7th/nvim-cmp"},
                        {"L3MON4D3/LuaSnip", after="hrsh7th/nvim-cmp"},
                        {"saadparwaiz0/cmp_luasnip", after="hrsh7th/nvim-cmp"},
                        {"nvim-telescope/telescope-github.nvim", after="hrsh7th/nvim-cmp" },
                        {"hrsh7th/cmp-nvim-lsp-signature-help", after="hrsh7th/nvim-cmp" },
                        {"hrsh7th/cmp-nvim-lsp-document-symbol", after="hrsh7th/nvim-cmp" },
                        {"hrsh7th/cmp-calc", after="hrsh7th/nvim-cmp" },
                        {"f3fora/cmp-spell", after="hrsh7th/nvim-cmp" },
                        {"yutkat/cmp-mocword", after="hrsh7th/nvim-cmp" },
                        {"nvim-lua/plenary.nvim", after="hrsh7th/nvim-cmp" },
                        {"onsails/lspkind.nvim", after="hrsh7th/nvim-cmp" },
                        {"petertriho/cmp-git", after="hrsh7th/nvim-cmp" },
                        {"ray-x/lsp_signature.nvim", after="hrsh7th/nvim-cmp" },
                },
                config = function()
                        require("pluginconfig/nvim-cmp")
                end
        }

        use {"hrsh7th/cmp-nvim-lsp"}
        use {"hrsh7th/cmp-buffer"}
        use {"hrsh7th/cmp-path"}
        use {"hrsh7th/cmp-cmdline"}
        use {"saadparwaiz1/cmp_luasnip"}
        use {"hrsh7th/cmp-nvim-lsp-signature-help"}
        use {"hrsh7th/cmp-nvim-lsp-document-symbol"}
        use {"hrsh7th/cmp-calc"}
        use {"f3fora/cmp-spell"}
        use {"yutkat/cmp-mocword"}
        use {
                "onsails/lspkind.nvim",
                config = function()
                        require("pluginconfig/lspkind")
                end
        }
        use {"petertriho/cmp-git"}
        use {"ray-x/lsp_signature.nvim"}

        use {"L3MON4D3/LuaSnip"}

        
        use {
                "nvim-lualine/lualine.nvim",
                requires = {
                        {"cocopon/pgmnt.vim"}, 
                        {"SmiteshP/nvim-navic", after = "nvim-lualine/lualine.nvim"}
                },
                config = function()
                        require("pluginconfig/lualine")
                end
        }
        use {"cocopon/pgmnt.vim"}

        use {
                "mvllow/modes.nvim",
                config = function()
                        require("pluginconfig/modes")
                end
        }

        use {
                "glepnir/lspsaga.nvim",
                branch = "main",
                config = function()
                        require("pluginconfig/lspsaga")
                end,
        }

        use {"rcarriga/nvim-notify"}

--        use {
--                "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
--                config = function()
--                        require("lsp_lines").setup()
--                end,
--        }

        use {
                "lewis6991/gitsigns.nvim",
                config = function()
                        require("pluginconfig/gitsigns")
                end
        }

        use {
                "windwp/nvim-autopairs",
                config = function() 
                        require("nvim-autopairs").setup {}
                end
        }

        use {
                "SmiteshP/nvim-navic",
                requires = "neovim/nvim-lspconfig",
                config = function()
                        require("pluginconfig/nvim-navic")
                end
        }

        use {
                "anuvyklack/pretty-fold.nvim",
                config = function()
                        require("pretty-fold").setup()
                end
        }

        use {
                "petertriho/nvim-scrollbar",
                config = function()
                        require("pluginconfig/nvim-scrollbar")
                end
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
                end
        }
        
        use {
                'numToStr/Comment.nvim',
                config = function()
                        require("pluginconfig/comment")
                end
        }

        use {
                "folke/trouble.nvim",
                requires = "kyazdani42/nvim-web-devicons",
                config = function()
                        require("pluginconfig/trouble")
                end
        }

        use {
                "yuki-yano/fuzzy-motion.vim",
                after = { "denops.vim" },
                config = function()
                        require("pluginconfig/fuzzy-motion")
                end
        }

        use {"mattn/vim-sonictemplate"}

        use {"simeji/winresizer"}

        use {
                -- using packer.nvim
                "akinsho/bufferline.nvim",
                tag = "v2.*",
                requires = "kyazdani42/nvim-web-devicons",
                config = function()
                        require("pluginconfig/bufferline")
                end
        }

        use {
                "folke/lsp-colors.nvim",
                config = function()
                        require("pluginconfig/lsp-colors")
                end
        }

        use {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                        require("pluginconfig/null-ls")
                end
        }


        use {
                "TimUntersberger/neogit",
                requires = { 
                        {"nvim-lua/plenary.nvim", after = "neogit"},
                },
                config = function()
                        require("pluginconfig/neogit")
                end
        }

        use {
                "sindrets/diffview.nvim",
                requires = { 
                        {"nvim-lua/plenary.nvim", after = "diffview.nvim"},
                },
                config = function()
                        require("pluginconfig/diffview")
                end
        }

        use {
                "j-hui/fidget.nvim",
                config = function()
                        require"fidget".setup{}
                end
        }

        use { "vim-jp/vimdoc-ja"}
        use { "mattn/emmet-vim"}
        use { "cohama/lexima.vim"}
        use { "mattn/vim-goimports"}
        use { "machakann/vim-sandwich"}
        use {
                "skanehira/denops-translate.vim",
                config = function()
                        require("pluginconfig/denops-translate")
                end
        }
        use {"kevinhwang91/promise-async"}
        use {"kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async"}
end)
