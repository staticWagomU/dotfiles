local sveltekit_target = {
  { target = "/%1/%+%2.svelte", context = "view" },
  { target = "/%1/%+%2.astro", context = "view" },
  { target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transform = "remove_server" },
  { target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transform = "add_server" },
}

return {
  "rgroli/other.nvim",
  opts = {
    require("other-nvim").setup({
      mappings = {
        -- builtin mappings
        "livewire",
        "angular",
        "laravel",
        "rails",
        "golang",
        -- sveltekit
        {
          pattern = "/(.*)/%+(.*).server.ts$",
          target = sveltekit_target,
        },
        {
          pattern = "/(.*)/%+(.*).server.js$",
          target = sveltekit_target,
        },
        {
          pattern = "/(.*)/%+(.*).ts$",
          target = sveltekit_target,
        },
        {
          pattern = "/(.*)/%+(.*).js$",
          target = sveltekit_target,
        },
        {
          pattern = "/(.*)/%+(.*).(svelte|astro)$",
          target = sveltekit_target,
        },
      },
      transformers = {
        -- defining a custom transformer
        lowercase = function (inputString)
          return inputString:lower()
        end
      },
      style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = "solid",

        -- Column seperator for the window
        seperator = "|",

        -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
        width = 0.7,

        -- min height in rows.
        -- when more columns are needed this value is extended automatically
        minHeight = 2
      },
    })
  },
  config = function (_, opts)
    require("other-nvim").setup(opts)
  end
}
