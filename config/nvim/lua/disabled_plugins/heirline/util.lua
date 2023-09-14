local M = {}
M.Align = { provider = "%=" }
M.Space = setmetatable(
{ provider = " " },
{
  __call = function(_, n)
    return { provider = string.rep(" ", n) }
  end
})
M.FillSpace = setmetatable(
{ provider = "━" },
{
  __call = function(_, n)
    return { provider = string.rep("━", n) }
  end
})
-- refs: https://github.com/yuki-yano/dotfiles/blob/2297ea2b2af4297ab613dd0ddec23199028e7842/.vim/lua/plugins/ui.lua#LL74C1-L90C10 
local function modified_buffers()
  local modified_background_buffers = vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr)
    and vim.api.nvim_buf_is_loaded(bufnr)
    and vim.api.nvim_buf_get_option(bufnr, "buftype") == ""
    and vim.api.nvim_buf_get_option(bufnr, "modifiable")
    and vim.api.nvim_buf_get_name(bufnr) ~= ""
    and vim.api.nvim_buf_get_number(bufnr) ~= vim.api.nvim_get_current_buf()
    and vim.api.nvim_buf_get_option(bufnr, "modified")
  end, vim.api.nvim_list_bufs())

  if #modified_background_buffers > 0 then
    return "!" .. #modified_background_buffers
  else
    return ""
  end
end
M.ModifiedBuffers = {
  M.Space,
  {
    provider = function()
      return modified_buffers()
    end,
  }
}

return M
