return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "folke/neoconf.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "ray-x/lsp_signature.nvim",
    "kevinhwang91/nvim-ufo",
    "kevinhwang91/promise-async",
  },
  config = function()
    ---@diagnostic disable-next-line: unused-local
    local nvim_lsp = require('lspconfig')
    local vim = vim
    require("mason-lspconfig").setup()
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
      end

      local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
      end

      buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

      local opts = { noremap = true, silent = true }

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      -- buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      -- buf_set_keymap("n", "?", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      -- buf_set_keymap("n", "g?", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
      -- buf_set_keymap("n", "[lsp]wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
      -- buf_set_keymap("n", "[lsp]wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
      -- buf_set_keymap("n", "[lsp]wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
      buf_set_keymap("n", "<Plug>(lsp);D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
      -- -- buf_set_keymap("n", "[lsp]rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      -- buf_set_keymap("n", "[lsp]a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      -- buf_set_keymap("n", "[lsp]e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      -- buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
      -- buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
      -- buf_set_keymap("n", "[lsp]q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
      buf_set_keymap("n", "<Plug>(lsp);l", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      buf_set_keymap("n", "gv", ":vsplit | lua vim.lsp.buf.definition()<CR>", opts)

      require("lsp_signature").on_attach()
      require("nvim-navic").attach(client, bufnr)
    end

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
    )

    local lspconfig = require("lspconfig")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
    local opts = { capabilities = capabilities, on_attach = on_attach }

    require("mason-lspconfig").setup_handlers({
      function(server_name)
        lspconfig[server_name].setup(opts)
      end,
      ["zls"] = function()
        lspconfig.zls.setup({
          settings = {
            zig = {
              enable_inlay_hints = true
            }
          }
        })
      end,
      ["lua_ls"] = function()
        lspconfig.sumneko_lua.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
      end,
      ["denols"] = function()
        lspconfig["denols"].setup({
          root_dir = lspconfig.util.root_pattern("deno.json"),
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
      ["tsserver"] = function()

        lspconfig["tsserver"].setup({
          root_dir = lspconfig.util.root_pattern("package.json"),
        })
      end,
      ["astro"] = function ()
        lspconfig["astro"].setup({
          root_dir = lspconfig.util.root_pattern("astro.config.mjs")
        })
      end,
    })

    require("lsp_signature").setup({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "single"
      },
      toggle_key = "<C-s>",
      select_signature_key = "<C-l>"
    })
  end
}

