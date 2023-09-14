return {
  "tomiis4/BufferTabs.nvim",
  opts = {
    ---@type 'none'|'single'|'double'|'rounded'|'solid'|'shadow'|table
    border = 'rounded',
    ---@type table<string>
    exclude = { 'NvimTree', 'help', 'dashboard', 'lir', 'alpha' },
    ---@type 'row'|'column'
    display = 'column',
    ---@type 'left'|'right'|'center'
    horizontal = 'right',
    ---@type 'top'|'bottom'|'center'
    vertical = 'top',
  },
  cond = function()
    return false
  end,
}
