local dpp = require("dpp")
local abbrev = require("utils").make_abbrev
local autocmd = require("utils").autocmd
local uc = require("utils").usercmd

local dppBase = require("dpp.helper").basePath
local tsPath = require("dpp.helper").tsPath

if dpp.load_state(dppBase) then
  autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("dpp#make_state start")
      dpp.make_state(dppBase, tsPath)
    end,
  })
end

autocmd("User", {
  pattern = "Dpp:makeStatePost",
  callback = function()
    vim.notify("dpp#make_state done")
    dpp.source()
    if require("utils").is_windows then
      vim.fn.system([[powershell -Command "rundll32 user32.dll,MessageBeep"]])
    else
      vim.fn.system([[paplay /usr/share/sounds/freedesktop/stereo/complete.oga]])
    end
  end,
})

autocmd({ "VimEnter" }, {
  pattern = "*",
  callback = function()
    require("dpp").source()
  end,
})

uc("DppMakeState", function()
  vim.notify("dpp#make_state start")
  dpp.make_state(dppBase, tsPath)
end)
uc("DppLoad", function()
  dpp.load_state(dppBase)
end)
uc("DppInstall", function()
  dpp.async_ext_action("installer", "install", { maxProcess = 10 })
end)
uc("DppUpdate", function()
  dpp.async_ext_action("installer", "update", { maxProcess = 10 })
end)
uc("DppSource", function()
  dpp.source()
  vim.notify("dpp#source done")
end)
uc("DppClear", function()
  dpp.clear_state()
end)

abbrev({
  { from = "dm", to = "DppMakeState" },
  { from = "dl", to = "DppLoad" },
  { from = "di", to = "DppInstall" },
  { from = "du", to = "DppUpdate" },
  { from = "ds", to = "DppSource" },
  { from = "dc", to = "DppClear" },
})

vim.cmd("filetype indent plugin on")
if vim.fn.has("syntax") then
  vim.cmd.syntax("on")
end
