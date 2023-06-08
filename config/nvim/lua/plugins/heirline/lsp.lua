local conditions = require("heirline.conditions")
local colors = require("nightfly").palette

return {
  condition = conditions.lsp_attached,
  {
    provider = "| ",
  },
  {
    update = { 'LspAttach', 'LspDetach', 'WinEnter' },
    provider  = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return table.concat(names, ", ")
    end,
    hl = { fg = colors.blue, bg = colors.slate_blue },
  },
  {
    provider = " |",
  },
}
