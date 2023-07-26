local conditions = require("heirline.conditions")
local colors = require("nightfly").palette

return {
  condition = conditions.lsp_attached,
  {
    provider = "| ",
  },
  {
    update = { 'LspAttach', 'LspDetach', 'WinEnter' },
    provider = function()
      local servers = vim
      .iter(vim.lsp.get_active_clients({ bufnr = 0 }))
      :map(function(server)
          return server.name
      end)
      :totable()
      return table.concat(servers, ', ')
    end,
    hl = { fg = colors.blue, bg = colors.slate_blue },
  },
  {
    provider = " |",
  },
}
