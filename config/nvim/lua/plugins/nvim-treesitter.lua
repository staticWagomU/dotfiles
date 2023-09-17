return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  config = function()
    require("nvim-treesitter.config").setup({
        highlight = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        ensure_installed = { 'astro', 'css', 'glimmer', 'graphql', 'handlebars', 'html', 'javascript', 'lua', 'nix', 'php', 'python', 'rescript', 'scss', 'svelte', 'tsx', 'twig', 'typescript', 'vim', 'vue', },
      })
  end,
}
