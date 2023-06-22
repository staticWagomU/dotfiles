return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "honza/vim-snippets",
    "rafamadriz/friendly-snippets",

    -- language specific snippets
    -- zig
    "Metalymph/zig-snippets",
    -- web
    "fivethree-team/vscode-svelte-snippets",
    "xabikos/vscode-javascript",
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
