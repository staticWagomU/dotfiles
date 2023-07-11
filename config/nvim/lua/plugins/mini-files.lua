return {
  "echasnovski/mini.files",
  version = false,
  config = function()
    require("mini.files").setup({
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = 'L',
        go_out      = 'h',
        go_out_plus = 'H',
        reset       = '<BS>',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
      },
      options = {
        permanent_delete = true,
        use_as_default_explorer = true,
      },
      windows = {
        preview = true,
      },
    })
  end,
}
