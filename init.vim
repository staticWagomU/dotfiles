let s:enable_coc = v:true
let s:enable_ddc = v:false


" {{{ options

set fileencodings=iso-2022-jp,ucs-bom,sjis,utf-8,euc-jp,cp932,default,latin1
set fileformats=unix,dos,mac

scriptencoding utf-8

set number
set helplang=ja
set signcolumn=yes 
set hidden
set laststatus=2
set mouse=a
set clipboard=unnamedplus
set title
let &g:titlestring =
      \ "%{expand('%:p:~:.')} %<\(%{fnamemodify(getcwd(), ':~')}\)%(%m%r%w%)"
" }}}

"{{{ plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-jp/vimdoc-ja'
Plug 'lambdalisue/fern.vim'
	Plug 'yuki-yano/fern-preview.vim'
	Plug 'lambdalisue/fern-git-status.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'mattn/emmet-vim'
Plug 'hrsh7th/vim-searchx'
Plug 'vim-denops/denops.vim'
Plug 'lambdalisue/gin.vim'
Plug 'simeji/winresizer'
Plug 'cohama/lexima.vim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
"}}}

"{{{ keymaps

"-------------------------------------------------------------------------------------------------+
" Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
" ================================================================================================+
" map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
" nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
" map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
" imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
" cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
" vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
" xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
" smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
" omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
" tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
" lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
"-------------------------------------------------------------------------------------------------+

let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>

inoremap <silent> jj <ESC>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" expand path
cmap <C-x> <C-r>=expand('%:p:h')<CR>\
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>

nnoremap <Leader>ls :<C-u>ls<CR>
nnoremap <Leader>w :<C-u>w<CR>
nnoremap <Leader>bn :<C-u>bn<CR>
nnoremap <Leader>bp :<C-u>bp<CR>
nnoremap <Leader>bd :<C-u>bd<CR>
"}}}

"{{{ pluginConfig

"{{{ ddc
if s:enable_ddc
endif
"}}}

"{{{ coc
if s:enable_coc
	nnoremap [dev]    <Nop>
	xnoremap [dev]    <Nop>
	nmap     m        [dev]
	xmap     m        [dev]

	let g:coc_global_extensions = ['coc-tsserver', 'coc-eslint8', 'coc-prettier', 'coc-git', 'coc-fzf-preview', 'coc-lists']

	inoremap <silent> <expr> <c-space> coc#refresh()
	nnoremap <silent> K       :<c-u>call <sid>show_documentation()<cr>
	nmap     <silent> [dev]rn <plug>(coc-rename)
	nmap     <silent> [dev]a  <plug>(coc-codeaction-selected)iw

	function! s:coc_typescript_settings() abort
	  nnoremap <silent> <buffer> [dev]f :<c-u>coccommand eslint.executeautofix<cr>:coccommand prettier.formatfile<cr>
	endfunction

	augroup coc_ts
	  autocmd!
	  autocmd filetype typescript,typescriptreact call <sid>coc_typescript_settings()
	augroup end

	function! s:show_documentation() abort
	  if index(['vim','help'], &filetype) >= 0
	    execute 'h ' . expand('<cword>')
	  elseif coc#rpc#ready()
	    call cocactionasync('dohover')
	  endif
	endfunction

endif
"}}}

" {{{ lualine
lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    --component_separators = { left = '', right = '' },
    --section_separators = { left = '', right = '' },
    --component_separators = '',
    --section_separators = '',
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
	lualine_a = { "mode" },
	lualine_b = { {"filename", path = 1} },
	lualine_c = {},
	lualine_x = { "encoding", "fileformat", "filetype" },
	lualine_y = { "filesize", "progress" },
	lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {'filename'},
    lualine_c = {},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
EOF
"}}}

"{{{ jumpcursor
nmap [j <Plug>(jumpcursor-jump)
"}}}

"{{{ fern
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer <CR>
nnoremap <silent> <Leader>E :<C-u>Fern . -drawer -toggle<CR>
let g:fern#default_hidden=1

function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
  nmap <silent> <buffer> <C-S-d> <Plug>(fern-action-new-dir)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END

autocmd FileType vim setlocal foldmethod=marker
"}}}

"{{{ fern-git-status
" Disable listing ignored files/directories
let g:fern_git_status#disable_ignored = 1
" Disable listing untracked files
let g:fern_git_status#disable_untracked = 1
" Disable listing status of submodules
let g:fern_git_status#disable_submodules = 1
" Disable listing status of directories
let g:fern_git_status#disable_directories = 1
"}}}

"{{{ vim-searchx
" Overwrite / and ?.
nnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
nnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
xnoremap ? <Cmd>call searchx#start({ 'dir': 0 })<CR>
xnoremap / <Cmd>call searchx#start({ 'dir': 1 })<CR>
cnoremap ; <Cmd>call searchx#select()<CR>

" Move to next/prev match.
nnoremap N <Cmd>call searchx#prev_dir()<CR>
nnoremap n <Cmd>call searchx#next_dir()<CR>
xnoremap N <Cmd>call searchx#prev_dir()<CR>
xnoremap n <Cmd>call searchx#next_dir()<CR>
nnoremap <C-k> <Cmd>call searchx#prev()<CR>
nnoremap <C-j> <Cmd>call searchx#next()<CR>
xnoremap <C-k> <Cmd>call searchx#prev()<CR>
xnoremap <C-j> <Cmd>call searchx#next()<CR>
cnoremap <C-k> <Cmd>call searchx#prev()<CR>
cnoremap <C-j> <Cmd>call searchx#next()<CR>
"}}}

"}}}

" {{{ autocmd
augroup restore-cursor
  autocmd!
  autocmd BufReadPost *
        \ : if line("'\"") >= 1 && line("'\"") <= line("$")
        \ |   exe "normal! g`\""
        \ | endif
  autocmd BufWinEnter *
  
        \ : if empty(&buftype) && line('.') > winheight(0) / 2
        \ |   execute 'normal! zz'
        \ | endif
augroup END

autocmd TermOpen * startinsert
"}}}

" {{{ other
cd ~

hi FgCocErrorFloatBgCocFloating guifg=#000000
" }}}
