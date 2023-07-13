return {
  provider = function()
    return require("lspsaga.symbol.winbar").get_bar()
  end,
  event = "LspAttach",
}
