return {
  "haya14busa/vim-asterisk",
  config = function()
    ---@param lhs string
    ---@param rhs string | function
    local map = function(lhs, rhs)
      vim.keymap.set({ "n", "v", "o" }, lhs, rhs, { noremap = false })
    end

    map("*", "<Plug>(asterisk-*)")
    map("#", "<Plug>(asterisk-#)")
    map("g*", "<Plug>(asterisk-g*)")
    map("g#", "<Plug>(asterisk-g#)")
    map("z*", "<Plug>(asterisk-z*)")
    map("gz*", "<Plug>(asterisk-gz*)")
    map("z#", "<Plug>(asterisk-z#)")
    map("gz#", "<Plug>(asterisk-gz#)")
  end,
}
