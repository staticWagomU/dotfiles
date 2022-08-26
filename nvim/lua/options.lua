vim.cmd[[
set number
set relativenumber
set nowrap
set helplang=ja
set signcolumn=yes 
set hidden
set laststatus=2
set mouse=a
set clipboard=unnamedplus
set ambiwidth=single
set ignorecase
set smartcase
set splitbelow
set splitright
set display=uhex
set wildmenu
set expandtab
set wrapscan
set termguicolors
set noshowmode
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set directory=~
set backupdir=~
set undodir=~
"set matchpairs+=「:」,（:）
set title
let &g:titlestring =
	\ "%{expand('%:p:~:.')} %<\(%{fnamemodify(getcwd(), ':~')}\)%(%m%r%w%)"

]]

vim.g.mapleader = " "
