return {
  provider = function()
    return require("lspsaga.symbolwinbar"):get_winbar()
  end,
  event = "LspAttach",
}
