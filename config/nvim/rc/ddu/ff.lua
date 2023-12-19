-- lua_source {{{
local do_action = 'conf.ddu.helper.do_action'
local opts = { noremap = true, silent = true, buffer = true }

local setKeymaps = require('utils').setKeymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'ddu-ff-filter',
  callback = function()
    setKeymaps('n', opts, {
        {
          'q',
          function()
            require('conf.ddu.helper')['do_action']('closeFilterWindow')
          end,
          'close filter window',
        },
      {
        '<Cr>',
        function()
          require('conf.ddu.helper')['do_action']('closeFilterWindow')
        end,
        'close filter window',
      },
    })
    setKeymaps('i', opts, {
      {
        '<Cr>',
        function()
          vim.cmd.stopinsert()
          require('conf.ddu.helper')['do_action']('closeFilterWindow')
        end,
        'close filter window',
      },
      {
        '<C-f>',
        { do_action, 'cursorNext', { loop = true } },
        'move cursor to next item',
      },
      {
        '<C-b>',
        { do_action, 'cursorPrev', { loop = true } },
        'move cursor to prev item',
      },
      {
        '<C-v>',
        { do_action, 'toggleAutoAction' },
        'toggle auto action',
      },
    })
  end,
  once = true,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'ddu-ff',
  callback = function()
    setKeymaps('n', opts, {
      { '<Cr>', { do_action, 'itemAction' }, 'exec item action' },
      { '<Space>', { do_action, 'toggleSelectItem' }, 'toggle select item' },
      { '*', { do_action, 'toggleAllItems' }, 'toggle all items' },
      { '<C-l>', { do_action, 'refreshItems' }, 'refresh items' },
      { 'p', { do_action, 'previewPath' }, 'preview path' },
      { 'P', { do_action, 'togglePreview' }, 'toggle preview' },
      { 'i', { do_action, 'openFilterWindow' }, 'open filter window' },
      { 'q', { do_action, 'quit' }, 'quit' },
      { 'a', { do_action, 'chooseAction' }, 'choose action' },
      { 'A', { do_action, 'inputAction' }, 'input action' },
      { 'r', { do_action, 'itemAction', { name = 'quickfix' } }, 'quickfix' },
      { 'yy', { do_action, 'itemAction', { name = 'yank' } }, 'yank item' },
      { 'gr', { do_action, 'itemAction', { name = 'grep' } }, 'grep item' },
    })
  end,
  once = true,
})

-- }}}
