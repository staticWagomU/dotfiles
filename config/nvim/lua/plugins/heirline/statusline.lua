local colors = require("nightfly").palette

local Mode = require("plugins/heirline/mode")
local Lsp = require("plugins/heirline/lsp")
local Diagnostics = require("plugins/heirline/diagnostics")
local FileEncoding = require("plugins/heirline/fileEncoding")
local FileType = require("plugins/heirline/fileType")
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
  FileType,
  Space,
  FileEncoding,
  Space,
  { provider = "| " },
  {
    provider = "%F",
    condition = vim.fn.expand("%F") ~= "",
    hl = { fg = colors.ash_blue, bg = colors.slate_blue },
  },
  { provider = " |" },
  Space,
  Mode,
}
