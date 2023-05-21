return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-calc",
    "dmitmel/cmp-cmdline-history",

    -- lsp
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",

    -- lua snip
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- copilot
    "hrsh7th/cmp-copilot",
    "github/copilot.vim",
--    "zbirenbaum/copilot.lua",
--    { "zbirenbaum/copilot-cmp", opts={} },

    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require("cmp")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local lspkind = require("lspkind")
    lspkind.init({
      symbol_map = {
        Copilot = "",
      },
    })

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      sources = cmp.config.sources(
      {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lua" },
        { name = "emoji" },
        { name = "calc" },
        { name = "buffer" },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol",
          with_text = true,
          maxwidth = 50
        }),
      },
    })

    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
      }, {
        { name = "buffer" },
      })
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "nvim_lsp_document_symbol" },
        { name = "buffer" },
      }
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      },
      {
        { name = "cmdline_history" },
      })
    })

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- Replace <YOUR_LSP_SERVER> with each lsp server you"ve enabled.
    -- require("lspconfig")["<YOUR_LSP_SERVER>"].setup {
    --   capabilities = capabilities
    -- }
  end
}
