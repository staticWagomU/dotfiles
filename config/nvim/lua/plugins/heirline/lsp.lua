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
      if server.name == 'null-ls' then
        local nulllsNames = {}
        -- null-lsの場合は実際に使っているソースを羅列して表示する
        table.insert(names, ('null-ls(%s)'):format(table.concat(
        vim
        .iter(require('null-ls.sources').get_available(vim.bo.filetype))
        :map(function(source)
          table.insert(names, source.name)
        end)
        :totable(),
        ','
        )))
      else
        -- null-ls以外の場合はサーバー名をそのまま表示する
        table.insert(names, server.name)
      end
      end
      return table.concat(names, ", ")
    end,
    hl = { fg = colors.blue, bg = colors.slate_blue },
  },
  {
    provider = " |",
  },
}
