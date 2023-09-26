---@diagnostic disable-next-line: unused-local
local enabled_vtsls = true

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  },
  config = function()
    local lspconfig = require("lspconfig")

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
          -- root_dir = lspconfig.util.root_pattern("astro.config.mjs", ".astro/")
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
      ["vtsls"] = function()
        local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
        if is_node and enabled_vtsls then
          lspconfig["vtsls"].setup({})
        end
      end,
      ["tsserver"] = function()
        local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
        if is_node and (not enabled_vtsls) then
          lspconfig["tsserver"].setup({})
        end
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
          root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "tailwind.config.lua",
            "tailwind.config.json"),
        })
      end,
      ["gopls"] = function()
        lspconfig["gopls"].setup({})
      end,
      ["emmet_ls"] = function()
        lspconfig["emmet_ls"].setup({
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
        lspconfig["cssls"].setup({})
      end,
      ["zls"] = function()
        lspconfig["zls"].setup({})
      end,
      ["ruby_ls"] = function()
        lspconfig["ruby_ls"].setup({})
      end,
      ["vuels"] = function()
        lspconfig["vuels"].setup({})
      end,
      ["svelte"] = function()
        lspconfig["svelte"].setup({})
      end,
      ["eslint"] = function()
        lspconfig["eslint"].setup({})
      end,
      ["volar"] = function()
        lspconfig["volar"].setup({})
      end,
      ["rust_analyzer"] = function()
        lspconfig["rust_analyzer"].setup({})
      end,
    })
  end,
  -- opts = function()
  --   local o = { opts = {} }
  --
  --   o.opts.capabilities = vim.tbl_deep_extend(
  --     "force",
  --     {},
  --     vim.lsp.protocol.make_client_capabilities(),
  --     {}
  --     )
  --   o.opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  --
  --   o.node_root_dir = {
  --     "package.json",
  --     "tsconfig.json",
  --     "tsconfig.jsonc",
  --     "node_modules",
  --   }
  --
  --   o.deno_root_dir = {
  --     "deno.json",
  --     "deno.jsonc",
  --   }
  --
  --   o.html_like = {
  --     "astro",
  --     "html",
  --     "htmldjango",
  --     "css",
  --     "javascriptreact",
  --     "javascript.jsx",
  --     "typescriptreact",
  --     "typescript.tsx",
  --     "svelte",
  --     "vue",
  --   }
  --
  --   o.disable_formatting = function(client)
  --     client.resolved_capabilities.document_formatting = false
  --     client.resolved_capabilities.document_range_formatting = false
  --     client.server_capabilities.documentFormattingProvider = false
  --   end
  --
  --   return o
  -- end,
  -- config = function(_, opts)
  --   local html_like = opts.html_like
  --   -- local node_root_dir = opts.node_root_dir
  --   -- local disable_formatting = opts.disable_formatting
  --   -- local deno_root_dir = opts.deno_root_dir
  --   opts = opts.opts
  --
  --   -- sign columnのアイコンを変更
  --   local signs = { Error = "", Warn = "", Hint = "", Info = "" }
  --   for type, icon in pairs(signs) do
  --     local hl = "DiagnosticSign" .. type
  --     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  --   end
  --   local lspconfig = require("lspconfig")
  --   vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  --   require("mason-lspconfig").setup({
  --       ensure_installed = {
  --         "astro",
  --         "denols",
  --         "vtsls",
  --         "tsserver",
  --         "lua_ls",
  --         "tailwindcss",
  --         "gopls",
  --         "emmet_ls",
  --         "cssls",
  --         "ruby_ls",
  --         "zls",
  --         "svelte",
  --         "volar",
  --         "rust_analyzer",
  --       },
  --     })
  --   require("mason-lspconfig").setup_handlers({
  --       function(server_name)
  --         lspconfig[server_name].setup()
  --       end,
  --       ["astro"] = function()
  --         lspconfig["astro"].setup({
  --             root_dir = lspconfig.util.root_pattern("astro.config.mjs", ".astro/")
  --           })
  --       end,
  --       ["denols"] = function()
  --         lspconfig["denols"].setup({
  --             root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json"),
  --             init_options = {
  --               lint = true,
  --               unstable = true,
  --               suggest = {
  --                 imports = {
  --                   hosts = {
  --                     ["https://deno.land"] = true,
  --                     ["https://cdn.nest.land"] = true,
  --                     ["https://crux.land"] = true,
  --                   },
  --                 },
  --               },
  --             },
  --           })
  --       end,
  --       ["vtsls"] = function()
  --         local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
  --         if is_node and enabled_vtsls then
  --           lspconfig["vtsls"].setup({})
  --         end
  --       end,
  --       ["tsserver"] = function ()
  --         local is_node = require("lspconfig").util.find_node_modules_ancestor(".")
  --         if is_node and (not enabled_vtsls) then
  --           lspconfig["tsserver"].setup({})
  --         end
  --       end,
  --       ["lua_ls"] = function()
  --         lspconfig["lua_ls"].setup({
  --             settings = {
  --               Lua = {
  --                 diagnostics = {
  --                   globals = { "vim" },
  --                 },
  --               },
  --             },
  --           })
  --       end,
  --       ["tailwindcss"] = function()
  --         lspconfig["tailwindcss"].setup({
  --             root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts", "tailwind.config.lua", "tailwind.config.json"),
  --           })
  --       end,
  --       ["gopls"] = function()
  --         lspconfig["gopls"].setup({})
  --       end,
  --       ["emmet_ls"] = function()
  --         lspconfig["emmet_ls"].setup({
  --             extra_filetype = html_like
  --           })
  --       end,
  --       ["cssls"] = function ()
  --         lspconfig["cssls"].setup({})
  --       end,
  --       ["zls"] = function ()
  --         lspconfig["zls"].setup({})
  --       end,
  --       ["ruby_ls"] = function ()
  --         lspconfig["ruby_ls"].setup({})
  --       end,
  --       ["vuels"] = function ()
  --         lspconfig["vuels"].setup({})
  --       end,
  --       ["svelte"] = function ()
  --         lspconfig["svelte"].setup({})
  --       end,
  --       ["eslint"] = function ()
  --         lspconfig["eslint"].setup({})
  --       end,
  --       ["volar"] = function ()
  --         lspconfig["volar"].setup({})
  --       end,
  --       ["rust_analyzer"] = function()
  --         lspconfig["rust_analyzer"].setup({})
  --       end,
  --     })
  -- end
}
