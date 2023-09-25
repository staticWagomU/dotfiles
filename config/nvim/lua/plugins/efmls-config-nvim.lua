return {
  "creativenull/efmls-configs-nvim",
  version = "v1.1.1",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    local eslint = require("efmls-configs.linters.eslint")
    local languages = require("efmls-configs.defaults").languages()
    languages = vim.tbl_extend("force", languages, {
      astro = { eslint },
    })

    local efmls_config = {
      filetypes = vim.tbl_keys(languages),
      settings = {
        rootMarkers = { ".git/" },
        languages = languages,
      },
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
    }

    require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {
      -- on_attach = on_attach,
      -- capabilities = capabilities,
    }))
  end,
}
