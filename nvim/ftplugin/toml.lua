vim.defer_fn(function()
  vim.fn['dpp#ext#toml#syntax']()
end, 150)

vim.keymap.set({ 'n' }, 'ml', function()
  local _start = vim.fn.search([[\v^lua_.*'''$]], 'bnW')

  local _end = vim.fn.search([[^''']], 'nW')
  if _start == 0 or _end == 0 then
    return
  end
  vim.fn.execute(_start + 1 .. ',' .. _end - 1 .. 'Partedit -filetype lua')
end, { buffer = true })
