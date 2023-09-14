local colors = require("nightfly").palette

return  {
  condition = (vim.bo.fenc ~= "" and vim.bo.fenc)  or vim.o.enc ~= "UFF-8",
  {provider = "| "},
  {
    init = function(self)
      self.enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
    end,
    provider = function(self)
      return self.enc:upper()
    end,
    hl = { fg = colors.ash_blue, bg = colors.slate_blue },

  },
  {provider = " |"},
}
