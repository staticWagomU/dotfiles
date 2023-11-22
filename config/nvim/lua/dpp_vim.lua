local dpp = require("dpp")
local autocmd = require("utils").autocmd
local uc = require("utils").usercmd
local keymap = vim.keymap.set

local dppBase = require("utils").dpp_basePath
local tsPath = vim.fs.joinpath(vim.fn.stdpath("config"), "rc", "dpp.ts")

if dpp.load_state(dppBase) then
  autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("dpp#make_state start")
      dpp.make_state(dppBase, tsPath)
    end,
  })
end

autocmd(
  { "User" },
  {
    pattern = "Dpp:makeStatePost",
    callback = function()
      vim.notify("dpp#make_state done")
      dpp.source()
    end,
  }
)



autocmd(
  { "CursorHold" },
  {
    pattern = [[*/rc/*.toml]],
    callback = function()
      vim.fn["dpp#ext#toml#syntax"]()
    end,
  }
)


uc( "DppMakeState", function() vim.notify("dpp#make_state start") dpp.make_state(dppBase, tsPath) end)
uc( "DppLoad", function() dpp.load_state(dppBase) end)
uc( "DppInstall", function() dpp.async_ext_action("installer", "install", { maxProcess = 10 }) end)
uc( "DppUpdate", function() dpp.async_ext_action("installer", "update", { maxProcess = 10 }) end)
uc(
  "DppSource",
  function()
    dpp.source()
    vim.notify("dpp#source done")
  end)
uc( "DppClear", function() dpp.clear_state() end)

keymap({ "n" }, "-", function() require("dpp").source() vim.notify("dpp#source done") end, { noremap = true, silent = true })


vim.cmd("filetype indent plugin on")
if vim.fn.has("syntax") then
  vim.cmd.syntax("on")
end
