local M = {}
-- ref:https://docs.coronalabs.com/tutorial/data/outputTable/index.html
--- dump table 
---@param t table
function M.dumpTable(t)
  local printTable_cache = {}

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

return M
