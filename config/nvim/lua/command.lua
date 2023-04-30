vim.api.nvim_create_user_command("Dot", function()
  local has = vim.fn.has
  if has("win") then 
    vim.cmd("lcd ~\\dotfiles\\config\\nvim")
  else
    vim.cmd("lcd ~/dotfiles/config/nvim")
  end
end, { force = true })

