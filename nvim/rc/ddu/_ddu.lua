--- lua_add {{{
local keymap = vim.keymap.set
vim.fn['ddu#custom#patch_local']('file_recursive', {
  ui = 'ff',
  uiParams = {
    ff = {
      filterFloatingPosition = 'bottom',
      filterSplitDirection = 'floating',
      floatingBorder = 'rounded',
      previewFloating = true,
      previewFloatingBorder = 'rounded',
      previewFloatingTitle = 'Preview',
      previewSplit = 'horizontal',
      prompt = '> ',
      split = 'floating',
      startFilter = true,
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
  },
  filterParams = {
    converter_hl_dir = {
      hlGoup = { 'Directory', 'Keyword' },
    },
  },
})

vim.fn['ddu#custom#patch_local']('colorscheme', {
  ui = 'ff',
  sources = {
    {
      name = { 'colorscheme' },
      options = {
        matchers = {
          'matcher_substring',
        },
        ignoreCase = true,
      },
    },
  },
  kindOptions = {
    colorscheme = {
      defaultAction = 'set',
    },
  },
})

vim.fn['ddu#custom#patch_local']('buffer_list', {
  ui = 'ff',
  uiParams = {
    ff = {
      filterFloatingPosition = 'top',
      filterSplitDirection = 'floating',
      floatingBorder = 'rounded',
      prompt = 'buffer > ',
      split = 'floating',
    },
  },
  sources = {
    {
      name = { 'buffer' },
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
    },
  },
  kindOptions = {
    file = {
      defaultAction = 'open',
    },
  },
  filterParams = {
    converter_hl_dir = {
      hlGoup = { 'Directory', 'Keyword' },
    },
  },
})
vim.cmd([[

function! s:ddu_grep() abort
    if system('git rev-parse --is-inside-work-tree') == "true\n"
        let l:cmd = 'git'
        let l:args = ['--no-pager', 'grep', '--line-number', '--column', '--no-color']
    else
        let l:cmd = 'rg'
        let l:args = ["--column", "--no-heading", "--color", "never"]
    endif

    let l:in = input('Pattern: ')

    if l:in == ''
        return
    endif
    call ddu#start(#{
                \ sources: ['rg'],
                \ sourceParams: #{
                \   rg: #{
                \     cmd: l:cmd,
                \     args: l:args,
                \     input: l:in,
                \   },
                \ },
                \ })
endfunction
]])
keymap('n', [[\g]], [[<Cmd>call <SID>ddu_grep()<Cr>]], { noremap = true, silent = true })
keymap('n', [[\f]], [[<Cmd>call ddu#start(#{name:'file_recursive'})<Cr>]], { noremap = true, silent = true })
keymap('n', [[\m]], [[<Cmd>Ddu mr<Cr>]], { noremap = true, silent = true })
keymap('n', [[\d]], [[<Cmd>Ddu dpp<Cr>]], { noremap = true, silent = true })
keymap('n', [[\l]], [[<Cmd>Ddu line<Cr>]], { noremap = true, silent = true })
keymap('n', [[\\]], [[<Cmd>Ddu patch_local<Cr>]], { noremap = true, silent = true })

--- }}}

-- lua_source {{{
vim.cmd([[
call ddu#custom#load_config(expand('~/dotfiles/config/nvim/rc/ddu/ddu.ts'))
]])
-- }}}
