return {
  {
    "catppuccin/nvim",
    priority =  1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "macchiato",
        },
        transparent_background = false,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          telescope = true,
          notify = true,
          mini = true,
          fern = true,
          mason = true,
          native_lsp = false,
          treesitter = true,
          lsp_trouble = true,
          sandwich = true,
        },
    })

      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end
  },
  {
    "mweisshaupt1988/neobeans.vim",
  }
}
