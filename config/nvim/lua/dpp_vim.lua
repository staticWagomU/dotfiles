local dpp = require("dpp")

local dppBase = require("utils").dpp_basePath
local tsPath = vim.fs.joinpath(vim.fn.stdpath("config"), "dpp.ts")
if dpp.load_state(dppBase) then

  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("start dpp#make_state")
      dpp.make_state(dppBase, tsPath)
    end,
  })
end

vim.api.nvim_create_autocmd({ "User" },
{
  pattern = "Dpp:makeStatePost",
  callback = function()
    vim.notify("dpp#make_state done")
  end,
}
)

vim.fn["dpp#source"]()

vim.api.nvim_create_user_command(
"DppInstall",
function()
  dpp.async_ext_action("installer", "install")
end,
{}
)
vim.api.nvim_create_user_command(
"DppUpdate",
function()
  dpp.async_ext_action("installer", "update")
end,
{}
)

vim.api.nvim_create_user_command(
"DppMakeState",
function()
  dpp.make_state(dppBase, tsPath)
end,
{}
)

vim.api.nvim_create_user_command(
"DppLoad",
function()
  dpp.load_state(dppBase)
end,
{}
)

vim.api.nvim_create_user_command(
"DppInstall",
function()
  dpp.async_ext_action("installer", "install", { maxProcess = 10 })
end,
{}
)
vim.api.nvim_create_user_command(
"DppUpdate",
function()
  dpp.async_ext_action("installer", "update", { maxProcess = 10 })
end,
{}
)
vim.api.nvim_create_user_command(
"DppSource",
function()
  vim.fn["dpp#source"]()
  dpp.source()
end,
{}
)
vim.api.nvim_create_user_command(
"DppClear",
function()
  dpp.clear_state()
end,
{}
)
vim.api.nvim_create_user_command(
"DppGet",
function()
  dpp.get()
end,
{}
)

vim.cmd("filetype indent plugin on")
if vim.fn.has("syntax") then
  vim.cmd.syntax("on")
end
