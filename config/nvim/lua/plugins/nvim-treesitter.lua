return {
  "nvim-treesitter/nvim-treesitter",
  -- dependencies = {
  --   "JoosepAlviste/nvim-ts-context-commentstring",
  -- },
  branch = "main",

  opts = {
    highlight = {
      enable = true,
    },
    ensure_installed = { 'astro', 'css', 'glimmer', 'graphql', 'handlebars', 'html', 'javascript', 'lua', 'nix', 'php', 'python', 'rescript', 'scss', 'svelte', 'tsx', 'twig', 'typescript', 'vim', 'vue', },
    -- context_commentstring = {
    --   enable = true,
    -- },
  },
}
