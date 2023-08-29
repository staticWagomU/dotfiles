return {
  "hrsh7th/nvim-pasta",
  config = function ()
    require('pasta').setup {
      paste_mode = false,
      fix_cursor = true,
      fix_indent = true,
      prevent_diagnostics = false,
      next_key = vim.api.nvim_replace_termcodes('<C-p>', true, true, true),
      prev_key = vim.api.nvim_replace_termcodes('<C-n>', true, true, true),
    }
    require('pasta').setup.filetype({ 'markdown', 'yaml' },  {
        converters = {},
      })
    vim.keymap.set({ 'n', 'x' }, 'p', require('pasta.mappings').p)
    vim.keymap.set({ 'n', 'x' }, 'P', require('pasta.mappings').P)
    vim.keymap.set({ 'n' }, '<C-p>', require('pasta.mappings').toggle_pin)
  end,
}
