---@diagnostic disable: undefined-doc-name
local M = {}
-- ref:https://docs.coronalabs.com/tutorial/data/outputTable/index.html
--- dump table 
---@param t table
function M.dumpTable(t)
  local printTable_cache = {}

---@diagnostic disable-next-line: redefined-local
  local function sub_printTable( t, indent )

    if ( printTable_cache[tostring(t)] ) then
      print( indent .. "*" .. tostring(t) )
    else
      printTable_cache[tostring(t)] = true
      if ( type( t ) == "table" ) then
        for pos,val in pairs( t ) do
          if ( type(val) == "table" ) then
            print( indent .. "[" .. pos .. "] => " .. tostring( t ).. " {" )
            sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
            print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
          elseif ( type(val) == "string" ) then
            print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
          else
            print( indent .. "[" .. pos .. "] => " .. tostring(val) )
          end
        end
      else
        print( indent..tostring(t) )
      end
    end
  end

  if ( type(t) == "table" ) then
    print( tostring(t) .. " {" )
    sub_printTable( t, "  " )
    print( "}" )
  else
    sub_printTable( t, "  " )
  end
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

-- ref: https://github.com/monaqa/dotfiles/blob/8f7766f142693e47fbef80d6cc1f02fda94fac76/.config/nvim/lua/rc/abbr.lua
---@param rules abbrrule[]
function M.make_abbrev(rules)
    -- 文字列のキーに対して常に0のvalue を格納することで、文字列の hashset を実現。
    ---@type table<string, abbrrule[]>
    local abbr_dict_rule = {}

    for _, rule in ipairs(rules) do
        local key = rule['from']
        if abbr_dict_rule[key] == nil then
            abbr_dict_rule[key] = {}
        end
        table.insert(abbr_dict_rule[key], rule)
    end

    for key, rules_with_key in pairs(abbr_dict_rule) do
        ---コマンドラインが特定の内容だったら、それに対応する値を返す。
        ---@type table<string, string>
        local d = {}

        for _, rule in ipairs(rules_with_key) do
            local required_pattern = rule['from']
            if rule['prepose_nospace'] ~= nil then
                required_pattern = rule['prepose_nospace'] .. required_pattern
            elseif rule['prepose'] ~= nil then
                required_pattern = rule['prepose'] .. " " .. required_pattern
            end
            d[required_pattern] = rule['to']
        end

        vim.cmd(([[
        cnoreabbrev <expr> %s (getcmdtype()==# ":") ? get(%s, getcmdline(), %s) : %s
        ]]):format(key, vim.fn.string(d), vim.fn.string(key), vim.fn.string(key)))
    end
end

return M
