return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  config = function()
    require("nvim-treesitter.config").setup({
      highlight = { enable = false, },
      ensure_installed = { "astro", "css", "glimmer", "graphql", "html", "javascript", "lua", "php", "python", "scss",
        "svelte", "tsx", "typescript", "vim", "vue", },
    })
  end,
}
