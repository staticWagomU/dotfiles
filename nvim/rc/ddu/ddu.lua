---@diagnostic disable: redefined-local
-- lua_add {{{
local ddu = require('conf.ddu.helper')
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

ddu.patch_local('file_recursive', {
  ui = 'ff',
  uiParams = {
    ff = {
      previewSplit = 'horizontal',
      prompt = '> ',
    },
  },
  sources = {
    {
      name = { 'file_rec' },
      options = {
        matchers = {
          'matcher_substring',
        },
        converters = {
          'converter_devicon',
          'converter_hl_dir',
        },
        ignoreCase = true,
      },
      params = {
        ignoredDirectories = { 'node_modules', '.git', '.vscode' },
      },
    },
  },
  kindOptions = {
    file = {
      defaultAction = 'open',
    },
    action = {
      defaultAction = 'do',
    },
  },
  filterParams = {
    matcher_substring = {
      hightlightMatched = 'Search',
    },
  },
})

keymap('n', [[\f]], function()
  ddu.start_local('file_recursive')
end, opts)
keymap('n', [[\\]], function()
  ddu.start({sources = {{name = {'patch_local'}}}})
end, opts)

-- }}}

-- lua_post_update {{{
require('conf.ddu.helper').set_static_import_path()
-- }}}


-- lua_source {{{
vim.cmd([[
call ddu#custom#load_config(expand('~/dotvim/nvim/rc/ddu/ddu.ts'))
]])
-- }}}
