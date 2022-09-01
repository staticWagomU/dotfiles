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

"autocmd bufWritePost *.zig !zig fmt %
]]

vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.g.mapleader = " "

