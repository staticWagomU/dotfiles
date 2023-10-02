return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  config = function()
    require("utils").on_attach(function()
      require("ufo").setup()
    end)
  end,
}
