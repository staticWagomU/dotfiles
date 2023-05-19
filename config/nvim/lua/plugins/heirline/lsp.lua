local conditions = require("heirline.conditions")
local colors = require("nightfly").palette

return {
  {
    provider = "| ",
    condition = conditions.lsp_attached,
  },
  {
    condition = conditions.lsp_attached,
    update = {"LspAttach", "LspDetach"},
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
    condition = conditions.lsp_attached,
  },
}
