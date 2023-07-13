local merge_arrays = function(a1, a2)
  if type(a2) ~= "table" then
    local a2 = { a2 }
  end

  for _, v in ipairs(a2) do
    table.insert(a1, v)
  end
  return a1
end


return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/prettier.nvim",
  },
  opts = function()
    local null_ls = require("null-ls")
    local diagnostics_format = "[#{c}] #{m} (#{s})"
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local with_root_file = function(...)
      local files = { ... }
      return function(utils)
        return utils.root_has_file(files)
      end
    end
    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
    local event = "BufWritePre" -- or "BufWritePost"
    local async = event == "BufWritePost"

    local prettier = require("prettier")

    prettier.setup({
      bin = 'prettierd', -- or `'prettierd'` (v0.23.3+)
      filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
        "astro",
        "svelte",
      },
    })

    null_ls.setup({
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.keymap.set("n", "<Leader>gf", function()
            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
          end, { buffer = bufnr, desc = "[lsp] format" })

          -- format on save
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
          vim.api.nvim_create_autocmd(event, {
            buffer = bufnr,
            group = group,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, async = async })
            end,
            desc = "[lsp] format on save",
          })
        end

        if client.supports_method("textDocument/rangeFormatting") then
          vim.keymap.set("x", "<Leader>gf", function()
            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
          end, { buffer = bufnr, desc = "[lsp] format" })
        end
      end,
    })

    local opts = {}
    opts.sources = merge_arrays(opts.sources or {}, {
      -- web
      -- diagnostics.eslint.with({
      --   diagnostics_format = diagnostics_format,
      --   condition = with_root_file(".eslintrc.cjs", ".eslintrc"),
      --   filetypes = {
      --     "javascript",
      --     "typescript",
      --     "astro",
      --     "javascriptreact",
      --     "javascript.jsx",
      --     "typescriptreact",
      --     "typescript.tsx",
      --     "svelte",
      --     "vue",
      --   }
      -- }),

      diagnostics.tsc.with({
        diagnostics_format = diagnostics_format,
        condition = with_root_file("deno.json", "deno.jsonc"),
      }),

      diagnostics.textlint.with({
        filetypes = { "markdown" }
      }),

      diagnostics.markuplint.with({
        filetypes = { "html", "astro" }
      }),

      -- format
      formatting.deno_fmt.with({
        condition = with_root_file("deno.json", "deno.jsonc"),
      }),

      -- lua
      formatting.stylua.with({
        diagnostics_format = diagnostics_format,
        condition = with_root_file({ "stylua.toml", ".stylua.toml" }),
      }),

      -- formatting.prettier.with({
      --   diagnostics_format = diagnostics_format,
      --   condition = with_root_file({ ".prettierrc", ".prettierrc.json" }),
      -- }),

    })
    return opts
  end,
}
