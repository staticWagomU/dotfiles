set nocompatible

" ----------
" Author:     @staticWagomU
" Created At: 2022-01-06
" 


" Index:----------------------------
"
" 1.
" Encoding:
"    
" 2.
" Options:
"
" 3.
" Plugin:
"
" 4.
" Variables:
"
" 5.
" Function:
"
" 6.
" Keymap:
"
" 7.
" Command:
"
" 8.
" Other:
" ----------------------------------


" ---------------------------------
" Encoding:
"

if has('vim_starting')
	" Has to be set first and once
	set encoding=utf8

	if exists('&termguicolors')
		set termguicolors
	endif

	filetype on
	filetype plugin on 
	filetype indent on

endif
" encoding
set fileencodings=iso-2022-jp,ucs-bom,sjis,utf-8,euc-jp,cp932,default,latin1
set fileformats=unix,dos,mac

scriptencoding utf-8


" ---------------------------------
" Options:
"


" helpを日本語表示
set helplang=ja

" 行番号表示
set number

" 行番号の左を常に表示
set signcolumn=yes 
" font
set guifont=Cica:h12

" ---
" search

set ignorecase smartcase
set incsearch
set wrapscan
set hlsearch


" ---
" edit

set smarttab
set noexpandtab
set tabstop=2
set shiftwidth=4
set shiftround
set autoindent smartindent
set backspace=indent,eol,start


" ファイル変更中でもファイルの変更を許可する
set hidden

" 内容が変更されたときに自動読み込み
set autoread


set nowrap


set laststatus=2


set ambiwidth=double


set modifiable

" マウススクロールを許可
set mouse=a


" System clipboard
set clipboard=unnamedplus

set wildmenu

set title




" ---------------------------------
" Plugin:
"


call plug#begin('~/.vim/plugged')

Plug 'vim-jp/vimdoc-ja'
Plug 'junegunn/fzf', {'dir': '~/.fzf_bin', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lambdalisue/fern.vim'
		Plug 'yuki-yano/fern-preview.vim'
		Plug 'lambdalisue/fern-git-status.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'sainnhe/gruvbox-material'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
"Plug 'mattn/vim-lsp-settings'
Plug 'mattn/emmet-vim'
Plug 'skanehira/jumpcursor.vim'
Plug 'itchyny/lightline.vim'
"Plug 'machakann/vim-sandwich'
Plug 'hrsh7th/vim-searchx'
Plug 'obaland/vfiler.vim'
Plug 'vim-denops/denops.vim'
Plug 'lambdalisue/gin.vim'
Plug 'simeji/winresizer'
Plug 'easymotion/vim-easymotion'
"Plug 'numToStr/Comment.nvim'


call plug#end()


colorscheme gruvbox-material


" ---------------------------------
" Variables:
"
let g:fern#default_hidden=1

let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1

let &g:titlestring =
      \ "%{expand('%:p:~:.')} %<\(%{fnamemodify(getcwd(), ':~')}\)%(%m%r%w%)"


"" ----------
"" lightline.vim
let g:lightline = {
		  \   'colorscheme': '',
      \   'component_function': {
      \     'modified_buffers': 'lightlinemodifiedbuffers()',
			\   },
      \ }

let s:lightline_ignore_filename_ft = [
	\ 'qf',
	\ 'fzf',
	\ 'defx',
	\ 'fern',
	\ 'coc-explorer',
	\ 'gina-status',
	\ 'gina-branch',
	\ 'gina-log',
	\ 'gina-reflog',
	\ 'gina-blame',
	\ ]



"" ----------
"" fzf-preview
let $BAT_THEME                     = 'gruvbox-material'
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'gruvbox-material'




"" ----------
"" vim-searchx
let g:searchx = {}
" Auto jump if the recent input matches to any marker.
let g:searchx.auto_accept = v:true
" The scrolloff value for moving to next/prev.
let g:searchx.scrolloff = &scrolloff
" To enable scrolling animation.
let g:searchx.scrolltime = 100
" To enable auto nohlsearch after cursor is moved
let g:searchx.nohlsearch = {}
let g:searchx.nohlsearch.jump = v:true
" Marker characters.
let g:searchx.markers = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.\zs')


"" ----------
"" fern-git-status
" Disable listing ignored files/directories
let g:fern_git_status#disable_ignored = 1
" Disable listing untracked files
let g:fern_git_status#disable_untracked = 1
" Disable listing status of submodules
let g:fern_git_status#disable_submodules = 1
" Disable listing status of directories
let g:fern_git_status#disable_directories = 1



" ---------------------------------
" Function:
"

"" ----------
"" lightline
function! LightlineModifiedBuffers() abort
   let modified_background_buffers = filter(range(1, bufnr('$')),
   \ { _, bufnr -> bufexists(bufnr) && buflisted(bufnr) && getbufvar(bufnr, 'buftype') ==# '' && filereadable(expand('#' . bufnr . ':p')) && bufnr != bufnr('%') && getbufvar(bufnr, '&modified') == 1 }
   \ )
 
   if count(s:lightline_ignore_filename_ft, &filetype)
     return ''
   endif
 
   if len(modified_background_buffers) > 0
     return '!' . len(modified_background_buffers)
   else
     return ''
   endif
endfunction


"" ----------
"" coc
function! s:coc_typescript_settings() abort
  nnoremap <silent> <buffer> [dev]f :<C-u>CocCommand eslint.executeAutofix<CR>:CocCommand prettier.formatFile<CR>
endfunction


"" ----------
"" Fern
function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
  nmap <silent> <buffer> <C-S-d> <Plug>(fern-action-new-dir)
endfunction

"" ----------
"" vim-searchx
" Convert search pattern.
function g:searchx.convert(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
endfunction


" ---------------------------------
" Keymap:
"

let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>


inoremap <silent> jj <ESC>

" expand path
cmap <C-x> <C-r>=expand('%:p:h')<CR>\
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>

nnoremap <Leader>ls :<C-u>ls<CR>
nnoremap <Leader>w :<C-u>w<CR>
nnoremap <Leader>bn :<C-u>bn<CR>
nnoremap <Leader>bp :<C-u>bp<CR>
nnoremap <Leader>bd :<C-u>bd<CR>

nnoremap [dev]    <Nop>
xnoremap [dev]    <Nop>
nmap     m        [dev]
xmap     m        [dev]
nnoremap [ff]     <Nop>
xnoremap [ff]     <Nop>
nmap     z        [ff]
xmap     z        [ff]

"" ----------
"" jumpcursor

nmap [j <Plug>(jumpcursor-jump)


"" ----------
"" coc.nvim
let g:coc_global_extensions = ['coc-tsserver', 'coc-eslint8', 'coc-prettier', 'coc-git', 'coc-fzf-preview', 'coc-lists']
inoremap <silent> <expr> <C-Space> coc#refresh()
nnoremap <silent> K       :<C-u>call <SID>show_documentation()<CR>
nmap     <silent> [dev]rn <Plug>(coc-rename)
nmap     <silent> [dev]a  <Plug>(coc-codeaction-selected)iw


"" ----------
"" fzf-preview

nnoremap <silent> <C-P>  :<C-u>CocCommand fzf-preview.FromResources buffer project_mru project<CR>
nnoremap <silent> [ff]s  :<C-u>CocCommand fzf-preview.GitStatus<CR>
noremap <silent> [ff]gg :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [ff]b  :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap          [ff]f  :<C-u>CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>
xnoremap          [ff]f  "sy:CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"

nnoremap <silent> [ff]q  :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<CR>
nnoremap <silent> [ff]rf :<C-u>CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent> [ff]d  :<C-u>CocCommand fzf-preview.CocDefinition<CR>
nnoremap <silent> [ff]t  :<C-u>CocCommand fzf-preview.CocTypeDefinition<CR>
nnoremap <silent> [ff]o  :<C-u>CocCommand fzf-preview.CocOutline --add-fzf-arg=--exact --add-fzf-arg=--no-sort<CR>

"" ----------
"" fern
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer <CR>
nnoremap <silent> <Leader>E :<C-u>Fern . -drawer -toggle<CR>



"" ----------
"" vim-searchx
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


"" ----------
"" vfiler
noremap <silent><Leader>f <Cmd>VFiler -layout=floating<CR>



"" ----------
"" emmet-vim
" noremap <C-y>, 


" ---------------------------------
" Command:
"

" :help event


" ターミナルモード移動時の初期モードを挿入モードにする
autocmd TermOpen * startinsert

augroup coc_ts
  autocmd!
  autocmd FileType typescript,typescriptreact call <SID>coc_typescript_settings()
augroup END

function! s:show_documentation() abort
  if index(['vim','help'], &filetype) >= 0
    execute 'h ' . expand('<cword>')
  elseif coc#rpc#ready()
    call CocActionAsync('doHover')
  endif
endfunction


if executable("typescript-language-server")
  " グローバルインストールされたnpmモジュールの保存場所
  let s:npm_root = trim(system("npm root -g"))

  " vim-lspのinitialization_optionsを使用して、typescript-deno-pluginのインストール場所をtypescript-language-serverへ伝えます
  let s:has_typescript_deno_plugin = isdirectory(s:npm_root . "/typescript-deno-plugin")
  let s:plugins = s:has_typescript_deno_plugin
    \ ? [{ "name": "typescript-deno-plugin", "location": s:npm_root }]
    \ : []
  augroup LspTypeScript
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
    \   "name": "typescript-language-server",
    \   "cmd": {server_info -> ["typescript-language-server", "--stdio"]},
    \   "root_uri": {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
    \   "whitelist": ["typescript", "typescript.tsx"],
    \   "initialization_options": { "plugins": s:plugins },
    \ })
  augroup END
endif


"" ----------
"" Fern


augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END

command! DenoRun silent only | botright 12 split |
   \ execute 'terminal deno ' .
   \ (expand('%:t') =~ '^\(.*[._]\)\?test\.\(ts\|tsx\|js\|mjs\|jsx\)$'
   \    ? 'test' : 'run')
   \ . ' -A --no-check --unstable --watch ' . expand('%:p') |
   \ stopinsert | execute 'normal! G' | set bufhidden=wipe |
   \ execute 'autocmd BufEnter <buffer> if winnr("$") == 1 | quit! | endif' |
   \ wincmd k



" ---------------------------------
" Other:
"

" nvim-qtを使用するため、初期ディレクトリDesktopに固定
cd ~


"" ----------
"" treesitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "typescript",
    "tsx",
  },
  highlight = {
    enable = true,
  },
}
EOF

