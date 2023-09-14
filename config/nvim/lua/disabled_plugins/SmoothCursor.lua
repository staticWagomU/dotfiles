return {
  "gen740/SmoothCursor.nvim" ,
  event = "BufReadPre",
  config = function()
    require('smoothcursor').setup({
      disable_float_win = true
    })
  end
}
