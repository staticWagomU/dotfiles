local M = {}

function M.do_action(action, args)
  if args ~= nil then
    vim.fn['ddu#ui#do_action'](action, args)
  else
    vim.fn['ddu#ui#do_action'](action)
  end
end

--- @param name string
function M.start_local(name)
  vim.fn['ddu#start'] {
    name = name,
  }
end

--- @param opts table
function M.start(opts)
  vim.fn['ddu#start'](opts)
end

function M.load_config(path)
  vim.fn['ddu#custom#load_config'](path)
end

function M.patch_global(dict)
  vim.fn['ddu#custom#patch_global'](dict)
end

function M.patch_local(name, dict)
  vim.fn['ddu#custom#patch_local'](name, dict)
end

function M.set_static_import_path()
  vim.fn['ddu#set_static_import_path']()
end

return M
