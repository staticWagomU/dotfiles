local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
}

function M.config() 
  require("nvim-treesitter.configs").setup {
    highlight = { enable = true, },
    ensure_installed = {
      "c",
      "cpp",
      "css",
      "diff",
      "gitignore",
      "go",
      "graphql",
      "help",
      "html",
      "javascript",
      "jsdoc",
      "jsonc",
      "lua",
      "markdown",
      "python",
      "regex",
      "rust",
      "scss",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vue",
      "wgsl",
      "yaml",
      "json",
      "astro",
    },
    sync_install = false,
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = false },
    context_commentstring = { enable = true, enable_autocmd = false },
  }
end

return M
