local has_cmp = function ()
  return require("lazy.core.config").plugins["nvim-cmp"] ~= nil
end

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "folke/neodev.nvim",
    { "hrsh7th/cmp-nvim-lsp", cond = has_cmp },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", cond = has_cmp },
  },
  opts = function()
    local o = { opts = {} }

    o.opts.capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp() and require("cmp_nvim_lsp").default_capabilities() or {}
    )
    o.opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    o.node_root_dir = {
      "package.json",
      "tsconfig.json",
      "tsconfig.jsonc",
      "node_modules",
    }

    o.html_like = {
      "astro",
      "html",
      "htmldjango",
      "css",
      "javascriptreact",
      "javascript.jsx",
      "typescriptreact",
      "typescript.tsx",
      "svelte",
      "vue",
    }

    o.disable_formatting = function(client)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      client.server_capabilities.documentFormattingProvider = false
    end

    return o
  end,
  config = function(_, opts)
    local html_like = opts.html_like
    local node_root_dir = opts.node_root_dir
    local disable_formatting = opts.disable_formatting
    opts = opts.opts

    -- sign columnのアイコンを変更
    local signs = { Error = "", Warn = "", Hint = "", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    require("neodev").setup({})
    local lspconfig = require("lspconfig")
    require("mason-lspconfig").setup({
      ensure_installed = {
        "astro",
        "denols",
        -- "vtsls",
        "tsserver",
        "lua_ls",
        "tailwindcss",
        "gopls",
        "emmet_ls",
        "cssls",
        "ruby_ls",
        "zls",
        "vuels",
        "svelte",
      },
    })
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup()
      end,
      ["astro"] = function()
        lspconfig["astro"].setup({
          root_dir = lspconfig.util.root_pattern("astro.config.mjs", ".astro/")
        })
      end,
      ["denols"] = function()
        lspconfig["denols"].setup({
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json"),
          init_options = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true,
                },
              },
            },
          },
        })
      end,
      -- ["vtsls"] = function()
      --   local deno_root = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
      --   if deno_root ~= nil then
      --     return
      --   end
      --   lspconfig["vtsls"].setup({
      --     root_dir = lspconfig.util.root_pattern("package.json"),
      --   })
      -- end,
      ["tsserver"] = function ()
        lspconfig["tsserver"].setup({})
      end,
      ["lua_ls"] = function()
        lspconfig["lua_ls"].setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
      end,
      ["tailwindcss"] = function()
        lspconfig["tailwindcss"].setup({
          root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "tailwind.config.lua", "tailwind.config.json"),
        })
      end,
      ["gopls"] = function()
        lspconfig["gopls"].setup({})
      end,
      ["emmet_ls"] = function()
        lspconfig["emmet_ls"].setup({
          extra_filetype = html_like
        })
      end,
      ["cssls"] = function ()
        lspconfig["cssls"].setup({})
      end,
      ["zls"] = function ()
        lspconfig["zls"].setup({})
      end,
      ["ruby_ls"] = function ()
        lspconfig["ruby_ls"].setup({})
      end,
      ["vuels"] = function ()
        lspconfig["vuels"].setup({})
      end,
      ["svelte"] = function ()
        lspconfig["svelte"].setup({})
      end,
    })
  end
}
