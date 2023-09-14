local sveltekit_target = {
  { target = "/%1/%+%2.svelte", context = "view" },
  { target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transform = "remove_server" },
  { target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transform = "add_server" },
}

return {
  "rgroli/other.nvim",
  config = function ()
    require("other-nvim").setup({
      mappings = {
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
          pattern = "/(.*)/%+(.*).(svelte)$",
          target = sveltekit_target,
        },
      },
      transformers = {
        lowercase = function (inputString)
          return inputString:lower()
        end
      },
      style = {
        border = "solid",
        seperator = "|",
        width = 0.7,
        minHeight = 2
      },
    })
  end
}
