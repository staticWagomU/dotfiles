return {
  "Shougo/ddu.vim",
  dependencies = {
    "vim-denops/denops.vim",
    "lambdalisue/kensaku.vim",
    "Shougo/ddu-commands.vim",
    ------------------------------
    -- | column                   |
    ------------------------------
    "Shougo/ddu-column-filename",
    "tamago3keran/ddu-column-devicon_filename",
    ------------------------------
    -- | filter                   |
    ------------------------------
    "Milly/ddu-filter-kensaku",
    "Shougo/ddu-filter-matcher_files",
    "Shougo/ddu-filter-matcher_relative",
    "Shougo/ddu-filter-matcher_substring",
    "Shougo/ddu-filter-sorter_alpha",
    "Shougo/ddu-filter-sorter_reversed",
    "kamecha/ddu-filter-converter_file_icon",
    "kamecha/ddu-filter-converter_file_info",
    "uga-rosa/ddu-filter-converter_devicon",
    ------------------------------
    -- | kind                     |
    ------------------------------
    "Shougo/ddu-kind-file",
    "Shougo/ddu-kind-word",
    ------------------------------
    -- | source                   |
    ------------------------------
    "4513ECHO/ddu-source-colorscheme",
    "4513ECHO/ddu-source-emoji",
    "Shougo/ddu-source-dummy",
    "Shougo/ddu-source-file",
    "Shougo/ddu-source-file_old",
    "Shougo/ddu-source-file_rec",
    "Shougo/ddu-source-line",
    "kuuote/ddu-source-git_diff",
    "kuuote/ddu-source-git_status",
    "kuuote/ddu-source-mr",
    "kyoh86/ddu-source-command",
    "kyoh86/ddu-source-git_branch",
    "kyoh86/ddu-source-git_diff_tree",
    "kyoh86/ddu-source-git_log",
    "kyoh86/ddu-source-lazy_nvim",
    "matsui54/ddu-source-command_history",
    "matsui54/ddu-source-file_external",
    "matsui54/ddu-source-help",
    "peacock0803sz/ddu-source-git_stash",
    "shun/ddu-source-buffer",
    "shun/ddu-source-rg",
    "uga-rosa/ddu-source-lsp",
    "uga-rosa/ddu-source-search_history",
    ------------------------------
    -- | ui                       |
    ------------------------------
    "Shougo/ddu-ui-ff",
    "Shougo/ddu-ui-filer",
  },
  config = function()
    vim.fn["ddu#custom#patch_global"]({
        ui = "ff",
        uiParams = {
          ff = {
            filterFloatingPosition = "bottom",
            filterSplitDirection = "floating",
            floatingBorder = "rounded",
            previewFloating = true,
            previewFloatingBorder = "rounded",
            previewFloatingTitle = "Preview",
            previewSplit = "horizontal",
            prompt = "> ",
            split = "floating",
            startFilter = true,
          }
        },
        sourceOptions = {
          _ = {
            matchers = {
              "matcher_substring",
            },
            ignoreCase = true,
          },
        },
      })

    vim.fn["ddu#custom#patch_local"]("file_recursive", {
        sources = {
          {
            name = { "file_rec" },
            options = {
              matchers = {
                "matcher_substring",
              },
              converters = {
                "converter_devicon",
              },
              ignoreCase = true,
            },
            params = {
              ignoredDirectories = { "node_modules", ".git", ".vscode" },
            },
          },
        },
        kindOptions = {
          file = {
            defaultAction = "open",
          }
        }
      })

    vim.fn["ddu#custom#patch_local"]("colorscheme", {
        sources = {
          {
            name = { "colorscheme" },
            options = {
              matchers = {
                "matcher_substring",
              },
            },
          },
        },
        kindOptions = {
          colorscheme = {
            defaultAction = "set",
          }
        }
      })

    vim.keymap.set({ "n" }, "<Leader>ff", [[<Cmd>call ddu#start(#{name: 'file_recursive'})<CR>]], { noremap = true, silent = true })

    vim.api.nvim_create_autocmd("FileType",{
        pattern = "ddu-ff",
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }
          vim.keymap.set({ "n" }, "q", [[<Cmd>call ddu#ui#ff#do_action("quit")<CR>]], opts)
          vim.keymap.set({ "n" }, "<Cr>", [[<Cmd>call ddu#ui#ff#do_action("itemAction")<CR>]], opts)
          vim.keymap.set({ "n" }, "i", [[<Cmd>call ddu#ui#ff#do_action("openFilterWindow")<CR>]], opts)
          vim.keymap.set({ "n" }, "P", [[<Cmd>call ddu#ui#ff#do_action("togglePreview")<CR>]], opts)
        end,
      })

    vim.api.nvim_create_autocmd("FileType",{
        pattern = "ddu-ff-filter",
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }
          vim.keymap.set({ "n", "i" }, "<CR>", [[<Esc><Cmd>close<CR>]], opts)
        end,
      })
  end,
}
