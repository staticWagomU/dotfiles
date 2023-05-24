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

    local opts = {}
    opts.sources = merge_arrays(opts.sources or {}, {
      -- web
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

      formatting.deno_fmt.with({
        condition = with_root_file("deno.json", "deno.jsonc"),
      }),

      -- format
      -- lua
      formatting.stylua.with({
        diagnostics_format = diagnostics_format,
        condition = with_root_file({ "stylua.toml", ".stylua.toml" }),
      }),

    })
    return opts
  end,
}
