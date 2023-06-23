return {
  {
    "Shougo/ddu.vim",
    dependencies = {
      "vim-denops/denops.vim",
      -- ui
      "Shougo/ddu-ui-ff",
      -- kind
      "Shougo/ddu-kind-file",
      -- source
      "Shougo/ddu-source-file",
      "Shougo/ddu-source-file_rec",
      "shun/ddu-source-buffer",
      { dir = "C:/dev/staticWagomU/ddu-source-keymap" },
      -- filter
      "Shougo/ddu-filter-matcher_substring",
    },
    config = function()
      -- local dduPath = vim.fs.joinpath(require("lazy.core.config").options.root, "ddu.ts")
      -- vim.fn["ddu#custom#load_config"](dduPath)

      vim.cmd[[
call ddu#custom#patch_global({
\   'ui': 'filer',
\   'sources': [
\     {
\       'name': 'file',
\       'params': {},
\     },
\   ],
\   'sourceOptions': {
\     '_': {
\       'columns': ['filename'],
\     },
\     'command_history': {
\       'matchers': [ 'matcher_substring' ],
\     },
\     'buffer': {
\       'matchers': [ 'matcher_substring' ],
\     },
\   },
\   'kindOptions': {
\     'file': {
\       'defaultAction': 'open',
\     },
\     'command_history': {
\       'defaultAction': 'execute',
\     },
\   },
\   'uiParams': {
\     'filer': {
\       'sort': 'filename',
\       'split': 'floating',
\       'displayTree': v:true,
\       'previewVertical': v:true,
\       'previewWidth': 80,
\     }
\   },
\ })

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> vo
        \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>
  nnoremap <buffer><silent> vs
        \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'split'}})<CR>
  nnoremap <buffer><silent> <Space>
        \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR>
  \ <Esc><Cmd>close<CR>
  nnoremap <buffer><silent> <CR>
  \ <Cmd>close<CR>
  nnoremap <buffer><silent> q
  \ <Cmd>close<CR>
endfunction

autocmd FileType ddu-filer call s:ddu_filer_my_settings()
function! s:ddu_filer_my_settings() abort
  nnoremap <buffer><silent><expr> <CR>
    \ ddu#ui#filer#is_tree() ?
    \ "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'narrow'})<CR>" :
    \ "<Cmd>call ddu#ui#filer#do_action('itemAction')<CR>"
  nnoremap <buffer><silent><expr> vo
    \ ddu#ui#filer#is_tree() ?
    \ "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'narrow'})<CR>" :
    \ "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>"
  nnoremap <buffer><silent> <Space>
        \ <Cmd>call ddu#ui#filer#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> <Esc>
    \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
  nnoremap <buffer> o
        \ <Cmd>call ddu#ui#filer#do_action('expandItem',
        \ {'mode': 'toggle'})<CR>
  nnoremap <buffer><silent> q
    \ <Cmd>call ddu#ui#filer#do_action('quit')<CR>
  nnoremap <buffer><silent> ..
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'narrow', 'params': {'path': '..'}})<CR>
  nnoremap <buffer><silent> c
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'copy'})<CR>
  nnoremap <buffer><silent> p
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'paste'})<CR>
  nnoremap <buffer><silent> d
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'delete'})<CR>
  nnoremap <buffer><silent> r
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'rename'})<CR>
  nnoremap <buffer><silent> mv
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'move'})<CR>
  nnoremap <buffer><silent> t
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'newFile'})<CR>
  nnoremap <buffer><silent> mk
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'newDirectory'})<CR>
  nnoremap <buffer><silent> yy
    \ <Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'yank'})<CR>
endfunction" `;f` でファイルリストを表示する
nmap <silent> ;f <Cmd>call ddu#start({
\   'name': 'filer',
\   'uiParams': {
\     'filer': {
\       'search': expand('%:p')
\     }
\   },
\ })<CR>

" `;b` でバッファリストを表示する
nmap <silent> ;b <Cmd>call ddu#start({
\   'ui': 'ff',
\   'sources': [{'name': 'buffer'}],
\   'uiParams': {
\     'ff': {
\       'split': 'floating',
\     }
\   },
\ })<CR>
      ]]
    end
  }
}

