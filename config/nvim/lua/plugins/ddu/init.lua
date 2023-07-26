return {
  {
    "Shougo/ddu.vim",
    dependencies = {
      "vim-denops/denops.vim",
      -- source
      "Shougo/ddu-source-file",
      "Shougo/ddu-source-file_rec",
      "shun/ddu-source-buffer",
      { dir = "C:/dev/staticWagomU/ddu-source-keymap" },
      -- filter
      "Shougo/ddu-filter-matcher_substring",
    },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ddu-ff",
        callback = function()
          local opts = {buffer = true, silent = true }
          vim.keymap.set("n", "<CR>", "<Cmd>call ddu#ui#ff#do_action('itemAction')<CR>", opts)
          vim.keymap.set("n", "i", "<Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>", opts)
          vim.keymap.set("n", "q", "<Cmd>call ddu#ui#ff#do_action('quit')<CR>", opts)
        end
      })
      vim.fn["ddu#custom#patch_local"]("buffers", {
          ui = "ff",
          sources = {
            {
              name = "buffer",
            },
          },
          sourceOptions = {
            _ = {
              ignoreCase = true,
              matchers = { "matcher_substring" },
            },
          },
          kindOptions = {
            file = {
              defaultAction = "open",
            },
          },
        })

      vim.fn["ddu#custom#patch_local"]("findFiles", {
        ui = "ff",
        sources = {
          {
            name = "file_rec",
            opts = {
              cwd = vim.fn.getcwd(),
            },
          },
        },
        soureOptions = {
          _ = {
            ignoreCase = true,
            matchers = { "matcher_substring" },
          },
        },
        kindOptions = {
          file = {
            defaultAction = "open",
          },
        },
      })
    end
  },
  -- ui
  {
    "Shougo/ddu-ui-ff",
    dependencies = {
      "Shougo/ddu.vim",
    }
  },
  -- kind
  {
    "Shougo/ddu-kind-file",
    dependencies = {
      "Shougo/ddu.vim",
    }
  },
}

