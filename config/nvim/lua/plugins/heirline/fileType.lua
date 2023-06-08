local colors = require("nightfly").palette

return {
  condition = vim.bo.filetype ~= "",
  {
    provider = "| ",
  },
  {
    provider = function ()
      return vim.bo.filetype
    end,
    hl = { fg = colors.ash_blue, bg = colors.slate_blue },
  },
  {
    provider = " |",
  },
}

