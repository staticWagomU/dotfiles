set nocompatible
set helplang=ja "help $BF|K\8l2=(B
set number "$B9THV9fI=<((B
set autoindent smartindent
set tabstop=2
set shiftwidth=2
set noexpandtab 
set backspace=indent,eol,start
set guifont=PlemolJP_Console:h12 "$B%U%)%s%H@_Dj(B
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

"$B%9%F!<%?%9%i%$%s@_Dj(B
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
" $B:G=*9T$K%Z!<%9%H(B
cmap <C-v> <C-v>
nmap <C-v> <C-v>
