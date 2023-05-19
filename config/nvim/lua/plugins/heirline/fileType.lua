local colors = require("nightfly").palette

return {
  {
    provider = "| ",
    condition = vim.bo.filetype ~= "",
  },
  {
    provider = function ()
      return vim.bo.filetype
    end,
    hl = { fg = colors.ash_blue, bg = colors.slate_blue },
    condition = vim.bo.filetype ~= "",
  },
  {
    provider = " |",
    condition = vim.bo.filetype ~= "",
  },
}

