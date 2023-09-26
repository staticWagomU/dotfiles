---@diagnostic disable-next-line: unused-local
local enabled_vtsls = true

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
    "Shougo/ddc.vim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    require("mason-lspconfig").setup({
      ensure_installed = {
        "astro",
        "denols",
        "vtsls",
        "tsserver",
        "lua_ls",
        "tailwindcss",
        "gopls",
        "emmet_ls",
        "cssls",
        "ruby_ls",
        "zls",
        "svelte",
        "volar",
        "rust_analyzer",
      },
    })

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup()
      end,
      ["astro"] = function()
        lspconfig["astro"].setup({
          capabilities = capabilities,
          -- root_dir = lspconfig.util.root_pattern("astro.config.mjs", ".astro/")
        })
      end,
      ["denols"] = function()
        lspconfig["denols"].setup({
          capabilities = capabilities,
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
      ["vtsls"] = function()
        local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
        if is_node and enabled_vtsls then
          lspconfig["vtsls"].setup({
            capabilities = capabilities,
          })
        end
      end,
      ["tsserver"] = function()
        local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
        if is_node and (not enabled_vtsls) then
          lspconfig["tsserver"].setup({
            capabilities = capabilities,
          })
        end
      end,
      ["lua_ls"] = function()
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
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
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "tailwind.config.lua",
            "tailwind.config.json"),
        })
      end,
      ["gopls"] = function()
        lspconfig["gopls"].setup({
          capabilities = capabilities,
        })
      end,
      ["emmet_ls"] = function()
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          extra_filetype = {
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
        })
      end,
      ["cssls"] = function()
        lspconfig["cssls"].setup({
          capabilities = capabilities,
        })
      end,
      ["zls"] = function()
        lspconfig["zls"].setup({
          capabilities = capabilities,
        })
      end,
      ["ruby_ls"] = function()
        lspconfig["ruby_ls"].setup({
          capabilities = capabilities,
        })
      end,
      ["vuels"] = function()
        lspconfig["vuels"].setup({
          capabilities = capabilities,
        })
      end,
      ["svelte"] = function()
        lspconfig["svelte"].setup({
          capabilities = capabilities,
        })
      end,
      ["eslint"] = function()
        lspconfig["eslint"].setup({
          capabilities = capabilities,
        })
      end,
      ["volar"] = function()
        lspconfig["volar"].setup({
          capabilities = capabilities,
        })
      end,
      ["rust_analyzer"] = function()
        lspconfig["rust_analyzer"].setup({
          capabilities = capabilities,
        })
      end,
    })
  end,
}
