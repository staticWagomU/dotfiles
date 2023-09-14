local colors = require("nightfly").palette

local Mode = require("plugins/heirline/mode")
local Lsp = require("plugins/heirline/lsp")
local Diagnostics = require("plugins/heirline/diagnostics")
local Align = require("plugins/heirline/util").Align
local Space = require("plugins/heirline/util").FillSpace

return {
  Mode,
  Space,
  Lsp,
  Space,
  Diagnostics,
  Align,
  Space,
  {
    provider = "| ",
    condition = vim.fn.expand("%F") ~= "",
  },
  {
    provider = "%F",
    condition = vim.fn.expand("%F") ~= "",
    hl = { fg = colors.ash_blue, bg = colors.slate_blue },
  },
  {
    provider = " |",
    condition = vim.fn.expand("%F") ~= "",
  },
  Space,
  Mode,
}
