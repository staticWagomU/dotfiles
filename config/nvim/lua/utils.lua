local M = {}

--- dump table 
---@param t table
---@return string
function M.dumpTable(t)
  if type(t) == 'table' then
    local s = '{ '
    for k,v in pairs(t) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. M.dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(t)
  end
end

return M
