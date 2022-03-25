set nocompatible
set helplang=ja "help 日本語化
set number "行番号表示
set autoindent smartindent
set tabstop=2
set shiftwidth=2
set noexpandtab 
set backspace=indent,eol,start
set guifont=PlemolJP_Console:h12 "フォント設定
set clipboard=unnamed,autoselect
set termguicolors
set hidden
set hlsearch
set ignorecase smartcase
set laststatus=2
set encoding=utf-8
set fileencodings=iso-2022-jp,ucs-bom,sjis,utf-8,euc-jp,cp932,default,latin1
set fileformats=unix,dos,mac
set ambiwidth=double

"ステータスライン設定
set statusline=
set statusline+=\ %F
set statusline+=\%r
set statusline+=\%m
set statusline+=\ %=
set statusline+=\ %{&fenc!=''?&fenc:&enc}
set statusline+=\ %#PmenuSel#
set statusline+=\ %3p%%
set statusline+=\ %4l:%4L
set statusline+=\(%03v) 

inoremap <silent> jj <ESC>
"nnoremap <CR> <NOP> 
"nnoremap <CR> :w<CR>
nnoremap <C-n> gt
nnoremap <C-p> gT
nnoremap / /\v
" expand path
cmap <C-x> <C-r>=expand('%:p:h')<CR>\
" expand file (not ext)
cmap <C-z> <C-r>=expand('%:p:r')<CR>

colorscheme wombat
syntax on

"source $VIMRUNTIME/mswin.vim
" 最終行にペースト
cmap <C-v> <C-v>
nmap <C-v> <C-v>
