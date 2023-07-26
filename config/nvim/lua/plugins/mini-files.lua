return {
  "echasnovski/mini.files",
  version = false,
  config = function()
    local columns = vim.opt.columns:get()
    local width = math.floor(columns * 0.8)
    local previewWidth = math.floor(width / 2)
    require("mini.files").setup({
      options = {
        permanent_delete = true,
        use_as_default_explorer = true,
      },
      windows = {
        preview = true,
        width_preview = previewWidth,
      },
    })
  end,
}
