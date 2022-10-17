local colors = require("neobeans.core").get_dark_colors()

require("lsp-colors").setup({
  Error = colors.red,
  Warning = colors.yellow,
  Information = colors.green,
  Hint = colors.orange,
})
