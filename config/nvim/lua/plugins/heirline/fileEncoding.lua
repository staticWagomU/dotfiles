local colors = require("nightfly").palette

return  {
  {provider = "| "},
  {
    init = function(self)
      self.enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
    end,
    provider = function(self)
      return self.enc:upper()
    end,
    condition = (vim.bo.fenc ~= "" and vim.bo.fenc)  or vim.o.enc ~= "utf-8",
    hl = { fg = colors.ash_blue, bg = colors.slate_blue },

  },
  {provider = " |"},
}
