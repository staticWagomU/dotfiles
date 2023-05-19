local colors = require("nightfly").palette

return  {
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  static = {
    mode_colors = {
      n = colors.ash_blue,
      i = colors.green,
      v = colors.purple,
      V =  colors.purple,
      ["\22"] =  colors.purple,
      c =  colors.orange,
      s =  colors.orange,
      S =  colors.orange,
      ["\19"] =  colors.orange,
      R =  colors.orange,
      r =  colors.orange,
      ["!"] =  colors.red,
      t =  colors.red,
    }
  },
  provider = "▌",
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    vim.api.nvim_set_hl(0, "StatusLine", {fg = self.mode_colors[mode], bg = colors.slate_blue})
    return { fg = self.mode_colors[mode], bg = colors.slate_blue }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}
