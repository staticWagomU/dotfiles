return {
  "nvimdev/guard.nvim",
  config = function()
    local ft = require("guard.filetype")

    -- use stylua to format lua files and no linter
    ft("lua"):fmt("stylua")

    local filetypes = {
      "css",
      "graphql",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "less",
      "markdown",
      "scss",
      "typescript",
      "typescriptreact",
      "yaml",
      "astro",
      "svelte",
    }
    ft(table.concat(filetypes, ",")):fmt("prettier")
    -- call setup LAST
    require("guard").setup({
      -- the only option for the setup function
      fmt_on_save = true,
    })
  end,
}
