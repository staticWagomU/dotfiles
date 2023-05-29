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

-- ref: https://www.reddit.com/r/neovim/comments/su0em7/comment/hx96ur0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

---The file system path separator for the current platform.
M.path_separator = "/"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
if M.is_windows == true then
  M.path_separator = "\\"
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
M.split = function(inputString, sep)
  local fields = {}

  local pattern = string.format("([^%s]+)", sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
M.path_join = function(...)
  local args = {...}
  if #args == 0 then
    return ""
  end

  local all_parts = {}
  if type(args[1]) =="string" and args[1]:sub(1, 1) == M.path_separator then
    all_parts[1] = ""
  end

  for _, arg in ipairs(args) do
    local arg_parts = M.split(arg, M.path_separator)
    vim.list_extend(all_parts, arg_parts)
  end
  return table.concat(all_parts, M.path_separator)
end

return M
