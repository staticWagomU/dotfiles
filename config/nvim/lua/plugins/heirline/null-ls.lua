local conditions = require 'heirline.conditions'
return {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach', 'WinEnter' },
  provider = function(_)
    -- ' [lua_ls null-ls(stylua)]'
    return (' [%s]'):format(table.concat(
    vim
    .iter(vim.lsp.get_active_clients { bufnr = 0 })
    :map(function(server)
      if server.name == 'null-ls' then
        -- null-lsの場合は実際に使っているソースを羅列して表示する
        return ('null-ls(%s)'):format(table.concat(
        vim
        .iter(require('null-ls.sources').get_available(vim.bo.filetype))
        :map(function(source)
          return source.name
        end)
        :totable(),
        ','
        ))
      else
        -- null-ls以外の場合はサーバー名をそのまま表示する
        return server.name
      end
    end)
    :totable(),
    ' '
    ))
  end,
  hl = { fg = 'green', bold = true },
}

